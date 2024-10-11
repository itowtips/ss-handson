class Blog::Agents::Nodes::PageController < ApplicationController
  include Cms::NodeFilter::View
  helper Cms::ListHelper

  public

  def pages
    Blog::Page.site(@cur_site).and_public(@cur_date).
      where(@cur_node.condition_hash)
  end

  def index
    @items = pages.
      order_by(@cur_node.sort_hash).
      page(params[:page]).
      per(@cur_node.limit)

    render_with_pagination @items
  end
end
