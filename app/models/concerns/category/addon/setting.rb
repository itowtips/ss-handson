module Category::Addon
  module Setting
    extend SS::Addon
    extend ActiveSupport::Concern

    included do
      embeds_ids :st_categories, class_name: "Category::Node::Base"
      permit_params st_category_ids: []
    end

    public
      def st_parent_categories
        categories = []
        parents = st_categories.sort_by { |cate| cate.filename.count("/") }
        while parents.present?
          parent = parents.shift
          parents = parents.map { |c| c.filename !~ /^#{parent.filename}\// ? c : nil }.compact
          categories << parent
        end
        categories
      end
  end
end
