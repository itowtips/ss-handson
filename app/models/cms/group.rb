class Cms::Group
  include SS::Model::Group
  include Cms::SitePermission
  include Contact::Addon::Group

  set_permission_name "cms_groups", :edit

  attr_accessor :cur_site, :cms_role_ids

  permit_params :cms_role_ids

  default_scope -> { active }
  scope :site, ->(site) { self.in(name: site.groups.pluck(:name).map{ |name| /^#{::Regexp.escape(name)}(\/|$)/ }) }

  validate :validate_sites, if: ->{ cur_site.present? }

  def users
    Cms::User.in(group_ids: id)
  end

  # def update_chorg_attributes(attributes)
  #   attributes.each do |k, v|
  #     if v.respond_to?(:update_entity)
  #       v.update_entity(self)
  #     elsif k.start_with?("contact_")
  #       main_contact = self.contact_groups.where(main_state: 'main').first
  #       if main_contact
  #         main_contact.send("#{k}=", v)
  #       end
  #     else
  #       self.send("#{k}=", v)
  #     end
  #   end
  # end
  # def update_chorg_attributes(attributes0)
  #   source_attributes = self.attributes.to_h
  #   source_attributes["contact_groups"] = self.contact_groups.to_a.map(&:attributes).map(&:to_h)
  #   main_contact = source_attributes["contact_groups"].find { |contact| contact["main_state"] == "main" }
  #   attributes0.each do |k, v|
  #     if v.respond_to?(:update_entity)
  #       v.update_entity(source_attributes)
  #     end
  #     if k.start_with?("contact_")
  #       if main_contact
  #         main_contact[k] = v
  #       end
  #     else
  #       source_attributes[k] = v
  #     end
  #   end
  #
  #   self.attributes = source_attributes
  # end
  def update_chorg_attributes(attributes0)
    item = self
    attributes = Hash.new { |hash, key| hash[key] = item[key] }
    attributes["contact_groups"] = self.contact_groups.map(&:attributes).map(&:to_h)
    main_contact = attributes["contact_groups"].find { |contact_group| contact_group["main_state"] == "main" }

    attributes0.each do |k, v|
      if v.respond_to?(:update_entity)
        v.update_entity(attributes)
      elsif k.start_with?("contact_")
        unless main_contact
          main_contact = { "main_state" => "main" }
          attributes["contact_groups"] << main_contact
        end
        main_contact[k] = v
      else
        attributes[k] = v
      end
    end

    self.attributes = attributes
  end

  private

  def validate_sites
    return if cur_site.group_ids.index(id)

    cond = cur_site.groups.map { |group| name =~ /^#{::Regexp.escape(group.name)}\// }.compact
    self.errors.add :name, :not_a_child_group if cond.blank?
  end
end
