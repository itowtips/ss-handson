class Cms::CheckLinksController < ApplicationController
  include Cms::BaseFilter
  include SS::ExecFilter

  navi_view "cms/main/navi"

  private
    def task_name
      "cms:check_links"
    end

    def task_command
      [ task_name, "site=#{@cur_site.host}" ]
    end

    def set_item
      @item = Cms::Task.find_or_create_by name: task_name, site_id: @cur_site.id, node_id: nil
    end
end
