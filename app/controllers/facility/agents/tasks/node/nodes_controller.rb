class Facility::Agents::Tasks::Node::NodesController < ApplicationController
  include Cms::PublicFilter::Node

  public
    def generate
      generate_node @node
    end
end
