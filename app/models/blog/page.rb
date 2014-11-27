class Blog::Page
  include Cms::Model::Page
  include Cms::Page::SequencedFilename
  include Cms::Addon::Meta
  include Cms::Addon::Body
  include Cms::Addon::File
  include Blog::Addon::Weather
  include Cms::Addon::Release
  include Cms::Addon::ReleasePlan
  include Cms::Addon::RelatedPage
  include Category::Addon::Category
  include Workflow::Addon::Approver

  default_scope ->{ where(route: "blog/page") }
end
