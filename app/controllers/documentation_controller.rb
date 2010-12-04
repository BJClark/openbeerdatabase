class DocumentationController < ApplicationController
  def show
    flash.now[:warning] = 'The API is currently a work-in-progress and is subject to change without notice.'

    expires_in(1.week, :public => true)

    render :action => params[:id]
  end
end
