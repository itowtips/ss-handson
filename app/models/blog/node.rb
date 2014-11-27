module Blog::Node
  class Base
    include Cms::Model::Node

    default_scope ->{ where(route: /^blog\//) }
  end

  class Page
    include Cms::Model::Node
    include Cms::Addon::PageList

    default_scope ->{ where(route: "blog/page") }
  end
end
