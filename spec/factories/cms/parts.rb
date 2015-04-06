FactoryGirl.define do
  trait :cms_part do
    site_id { cms_site.id }
    user_id { cms_user.id }
    name "#{unique_id}"
    filename { "#{name}.part.html" }
    route "cms/free"
  end

  factory :cms_part, class: Cms::Part, traits: [:cms_part] do
    mobile_view  :show
  end

  factory :cms_part_base, class: Cms::Part::Base, traits: [:cms_part] do
    route "cms/base"
  end

  factory :cms_part_free, class: Cms::Part::Free, traits: [:cms_part] do
    route "cms/free"
  end

  factory :cms_part_node, class: Cms::Part::Node, traits: [:cms_part] do
    route "cms/node"
  end

  factory :cms_part_page, class: Cms::Part::Page, traits: [:cms_part] do
    route "cms/page"
  end

  factory :cms_part_tabs, class: Cms::Part::Tabs, traits: [:cms_part] do
    route "cms/tabs"
  end

  factory :cms_part_crumb, class: Cms::Part::Crumb, traits: [:cms_part] do
    route "cms/crumb"
  end
end
