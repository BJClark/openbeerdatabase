class Api::V1::BaseController < ApplicationController
  protected

  def authenticate
    head(:unauthorized) unless current_user.present?
  end

  def current_user
    User.find_by_token(params[:token]) if params[:token].present?
  end
  memoize :current_user
end
