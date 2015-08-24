class Sys::UsersController < ApplicationController
  include Sys::BaseFilter
  include Sys::CrudFilter

  model SS::User

  menu_view "sys/crud/menu"

  private
    def set_crumbs
      @crumbs << [:"sys.user", sys_users_path]
    end

    def fix_params
      { cur_user: @cur_user }
    end

  public
    def index
      raise "403" unless @model.allowed?(:edit, @cur_user)
      @items = @model.allow(:edit, @cur_user).
        search(params[:s]).
        order_by(_id: -1).
        page(params[:page]).per(50)
    end
end
