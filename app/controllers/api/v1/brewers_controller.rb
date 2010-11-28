class Api::V1::BrewersController < Api::V1::BaseController
  def index
    brewers = Brewer.paginate(params)

    render :json => {
      :page    => brewers.current_page,
      :brewers => brewers
    }
  end

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
