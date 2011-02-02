class Api::V1::BreweriesController < Api::V1::BaseController
  def index
    @breweries = Brewery.paginate(params)
  end

  def show
    @brewery = Brewery.find(params[:id])

    if params[:token].present?
      head(:unauthorized) unless @brewery.user == current_user
    end
  end

  def create
    brewery = current_user.breweries.build(params[:brewery])

    if brewery.save
      head :created, :location => v1_brewery_url(brewery, :format => :json)
    else
      render :json   => { :errors => brewery.errors },
             :status => :bad_request
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
