module Blog::Addon
  module Author
    extend ActiveSupport::Concern
    extend SS::Addon

    included do
      field :author, type: String
      permit_params :author
    end
  end
end
