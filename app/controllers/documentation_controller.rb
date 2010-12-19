class DocumentationController < ApplicationController
  def show
    expires_in(1.week, :public => true)

    render :action => params[:id]
  end
end
