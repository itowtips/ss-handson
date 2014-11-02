module Cms::NodeFilter
  extend ActiveSupport::Concern
  include Cms::CrudFilter

  included do
    before_action :change_item_class, if: -> { @item.present? }
  end

  private
    def append_view_paths
      append_view_path ["app/views/cms/nodes", "app/views/ss/crud"]
    end

    def change_item_class
      @item.route = params[:route] if params[:route]
      @item  = @item.becomes_with_route rescue @item
      @model = @item.class
    end

    def redirect_url
      diff = @item.route.pluralize != params[:controller]
      diff ? node_node_path(cid: @cur_node, id: @item.id) : { action: :show, id: @item.id }
    end

  public
    def new
      @item = @model.new pre_params.merge(fix_params)
      change_item_class

      raise "403" unless @item.allowed?(:edit, @cur_user, site: @cur_site, node: @cur_node)
    end

    def create
      @item = @model.new get_params
      change_item_class

      raise "403" unless @item.allowed?(:edit, @cur_user, site: @cur_site, node: @cur_node)
      render_create @item.save, location: redirect_url
    end

    def update
      @item.attributes = get_params
      @item.in_updated = params[:_updated] if @item.respond_to?(:in_updated)
      raise "403" unless @item.allowed?(:edit, @cur_user, site: @cur_site, node: @cur_node)
      render_update @item.update, location: redirect_url
    end
end
