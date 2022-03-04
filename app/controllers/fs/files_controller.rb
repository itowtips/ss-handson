class Fs::FilesController < ApplicationController
  include SS::AuthFilter
  include Member::AuthFilter
  include Cms::PublicFilter::Site

  before_action :set_user
  before_action :set_item
  before_action :deny
  rescue_from StandardError, with: :rescue_action

  private

  def set_user
    @cur_user, _login_path, _logout_path = get_user_by_access_token
    @cur_user ||= get_user_by_session
    SS.current_user = @cur_user
  end

  def set_item
    id = params[:id_path].present? ? params[:id_path].delete('/') : params[:id]
    name_or_filename = params[:filename]
    name_or_filename << ".#{params[:format]}" if params[:format].present?

    item = SS::File.find(id)
    if item.name == name_or_filename || item.filename == name_or_filename
      @item = item.becomes_with_model
      @variant = nil
      return
    end

    item = item.becomes_with_model
    variant = item.variants.from_filename(name_or_filename)
    raise "404" if !variant

    @item = item
    @variant = variant
  end

  def deny
    raise "404" unless @item.previewable?(site: @cur_site, user: @cur_user, member: get_member_by_session)
    set_last_logged_in
  end

  def set_last_modified
    response.headers["Last-Modified"] = CGI::rfc1123_date(@item.updated.in_time_zone)
  end

  def rescue_action(error = nil)
    if error.to_s.numeric?
      status = error.to_s.to_i
      file = error_html_file(status)
      return ss_send_file(file, status: status, type: Fs.content_type(file), disposition: :inline)
    end
    if error.is_a?(Mongoid::Errors::DocumentNotFound)
      status = 404
      file = error_html_file(status)
      return ss_send_file(file, status: status, type: Fs.content_type(file), disposition: :inline)
    end
    raise error
  end

  def error_html_file(status)
    if @cur_site && @cur_user.nil?
      file = "#{@cur_site.path}/#{status}.html"
      return file if Fs.exist?(file)
    end

    file = "#{Rails.public_path}/.error_pages/#{status}.html"
    Fs.exist?(file) ? file : "#{Rails.public_path}/.error_pages/500.html"
  end

  def send_item(disposition = :inline)
    path = @variant ? @variant.path : @item.path
    @variant.create! if @variant
    raise "404" unless Fs.file?(path)

    set_last_modified

    content_type = @variant ? @variant.content_type : @item.content_type
    download_filename = @variant ? @variant.download_filename : @item.download_filename
    ss_send_file @variant || @item, type: content_type, filename: download_filename, disposition: disposition
  end

  public

  def index
    send_item
  end

  def thumb
    size   = params[:size]
    width  = params[:width]
    width  = width.numeric? ? width.to_i : nil
    height = params[:height]
    height = height.numeric? ? height.to_i : nil

    if width.present? && height.present? && width > 0 && height > 0
      @variant = @item.variants[{ width: width, height: height }]
    elsif size.present? && (variant = @item.variants[size.to_s.to_sym])
      @variant = variant
    else
      @variant = @item.variants[:thumb]
    end

    set_last_modified
    send_item
  rescue => e
    raise "500"
  end

  def download
    send_item(DEFAULT_SEND_FILE_DISPOSITION)
  end

  alias view index
end
