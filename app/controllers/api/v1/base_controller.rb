class Api::V1::BaseController < ApplicationController
  protected

  def authenticate
    head :unauthorized unless current_user.present?
  end

  def current_user
    @current_user ||= User.find_by_token(params['token'])
  end
end
