class Api::V1::BaseController < ApplicationController
  before_filter :authenticate,                   :only   => [:create, :destroy]
  before_filter :validate_format,                :except => [:destroy]
  after_filter  :correct_content_type_for_jsonp, :only   => [:index, :show], :if => :callback_provided?

  caches_action :index, :show, :expires_in => 15.minutes, :if => :callback_provided?

  protected

  def authenticate
    head(:unauthorized) unless current_user.present?
  end

  def callback_provided?
    params[:callback].present?
  end

  def correct_content_type_for_jsonp
    self.content_type = Mime::JS
  end

  def current_user
    User.find_by_token(params[:token]) if params[:token].present?
  end
  memoize :current_user

  def validate_format
    head(:not_acceptable) unless request.format.json?
  end
end
