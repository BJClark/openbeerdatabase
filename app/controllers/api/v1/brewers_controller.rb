class Api::V1::BrewersController < Api::V1::BaseController
  before_filter :authenticate, :only => [:create]

  def create
    brewer = Brewer.new(params[:brewer])
    brewer.user = current_user

    if brewer.save
      head :created
    else
      head :bad_request
    end
  end
end
