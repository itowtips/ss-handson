class Cms::Notice
  extend SS::Translation
  include SS::Document
  include SS::Reference::Site
  include Cms::Addon::ReleasePlan
  include Cms::Addon::Body
  include Cms::Addon::File
  include Cms::Addon::GroupPermission

  NOTICE_SEVERITY_NORMAL = "normal".freeze
  NOTICE_SEVERITY_HIGH ="high".freeze
  NOTICE_SEVERITIES = [ NOTICE_SEVERITY_NORMAL, NOTICE_SEVERITY_HIGH ]

  NOTICE_TARGET_ALL = "all".freeze
  NOTICE_TARGET_SAME_GROUP = "same_group".freeze
  NOTICE_TARGETS = [ NOTICE_TARGET_ALL, NOTICE_TARGET_SAME_GROUP ].freeze

  seqid :id
  field :name, type: String
  field :notice_severity, type: String, default: NOTICE_SEVERITY_NORMAL
  field :notice_target, type: String, default: NOTICE_TARGET_ALL
  permit_params :name, :notice_severity, :notice_target
  validates :name, presence: true, length: { maximum: 80 }

  class << self
    def search(params = {})
      criteria = self.where({})
      return criteria if params.blank?

      if params[:name].present?
        criteria = criteria.search_text params[:name]
      end
      if params[:keyword].present?
        criteria = criteria.keyword_in params[:keyword], :name, :html
      end
      criteria
    end

    def public(date = Time.zone.now)
      where("$and" => [
        { "$or" => [ { release_date: nil }, { :release_date.lte => date } ] },
        { "$or" => [ { close_date: nil }, { :close_date.gt => date } ] },
      ])
    end

    def target_to(user)
      where("$or" => [
        { notice_target: NOTICE_TARGET_ALL },
        { "$and" => [ { notice_target: NOTICE_TARGET_SAME_GROUP }, { :group_ids.in => user.group_ids } ] }
      ])
    end
  end

  public
    def notice_severity_options
      NOTICE_SEVERITIES.map { |v| [ I18n.t("cms.options.notice_severity.#{v}"), v ] }.to_a
    end

    def notice_target_options
      NOTICE_TARGETS.map { |v| [ I18n.t("cms.options.notice_target.#{v}"), v ] }.to_a
    end

    def new_clone(attributes = {})
      attributes = self.attributes.merge(attributes).select{ |k| self.fields.keys.include?(k) }

      item = self.class.new(attributes)
      item.id = nil
      item.cur_site = @cur_site
      # item.cur_node = @cur_node
      item.instance_variable_set(:@new_clone, true)
      item
    end

    def new_clone?
      @new_clone == true
    end

    def clone_files
      ids = SS::Extensions::Words.new
      files.each do |f|
        attributes = Hash[f.attributes]
        attributes.select!{ |k| f.fields.keys.include?(k) }

        file = SS::File.new(attributes)
        file.id = nil
        file.in_file = f.uploaded_file
        file.user_id = @cur_user.id if @cur_user

        file.save validate: false
        ids << file.id.mongoize

        html = self.html
        html.gsub!("=\"#{f.url}\"", "=\"#{file.url}\"")
        html.gsub!("=\"#{f.thumb_url}\"", "=\"#{file.thumb_url}\"")
        self.html = html
      end
      self.file_ids = ids
    end
end
