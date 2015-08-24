class Cms::ContentsController < ApplicationController
  include Cms::BaseFilter

  navi_view "cms/main/navi"

  private
    def set_crumbs
      @crumbs << [:"cms.content", action: :index]
    end

  public
    def index
      @model = Cms::Node
      self.menu_view_file = nil

      @mod = params[:mod]
      cond = {}
      cond[:route] = /^#{Regexp.escape(@mod)}\// if @mod.present?

      @items = Cms::Node.site(@cur_site).
        allow(:read, @cur_user).
        where(cond).
        where(shortcut: :show).
        order_by(filename: 1).
        page(params[:page]).per(100)

      @notices = Cms::Notice.site(@cur_site).public.target_to(@cur_user).order_by(updated: -1)
    end

    def public_notice
      @model = Cms::Notice
      self.menu_view_file = "public_notice_menu"
      @item = Cms::Notice.site(@cur_site).public.target_to(@cur_user).find(params[:notice])
    end
end
