class Api::V1::BreweriesController < Api::V1::BaseController
  def index
    @breweries = Brewery.paginate(params)
  end

  def show
    @brewery = Brewery.find(params[:id])

    if params[:token].present?
      head(:unauthorized) unless @brewery.user == current_user
    end
  rescue ActiveRecord::RecordNotFound
    head :not_found
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

  def destroy
    brewery = Brewery.find(params[:id])

    if brewery.user == current_user
      if brewery.beers.count == 0
        brewery.destroy

        head :ok
      else
        head :bad_request
      end
    else
      head :unauthorized
    end
  end
end
