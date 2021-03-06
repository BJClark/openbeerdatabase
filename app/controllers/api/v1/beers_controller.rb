class Api::V1::BeersController < Api::V1::BaseController
  def index
    @beers = Beer.paginate(params)
  end

  def show
    @beer = Beer.find(params[:id])

    if params[:token].present?
      head(:unauthorized) unless @beer.user == current_user
    end
  end

  def create
    beer = current_user.beers.build(params[:beer])
    beer.brewery = current_user.breweries.find_by_id(params[:brewery_id])

    if beer.save
      head :created, :location => v1_beer_url(beer, :format => :json)
    else
      render :json   => { :errors => beer.errors },
             :status => :bad_request
    end
  end

  def destroy
    beer = Beer.find(params[:id])

    if beer.user == current_user
      beer.destroy

      head :ok
    else
      head :unauthorized
    end
  end
end
