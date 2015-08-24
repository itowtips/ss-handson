class Facility::Agents::Nodes::LocationController < ApplicationController
  include Cms::NodeFilter::View

  public
    def index
      @items = Facility::Node::Page.site(@cur_site).public.
        where(@cur_node.condition_hash).
        order_by(@cur_node.sort_hash)
    end
end
