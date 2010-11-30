class Api::V1::BreweriesController < Api::V1::BaseController
  def index
    @breweries = Brewery.paginate(params)
  end

  def create
    brewery = Brewery.new(params[:brewery])
    brewery.user = current_user

    if brewery.save
      head :created
    else
      head :bad_request
    end
  end
end
