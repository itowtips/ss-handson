module Cms::ApiFilter
  extend ActiveSupport::Concern
  include Cms::BaseFilter
  include SS::CrudFilter
  include SS::AjaxFilter

  public
    def index
      @items = @model.site(@cur_site).
        search(params[:s]).
        order_by(_id: -1).
        page(params[:page]).per(50)
    end
end
