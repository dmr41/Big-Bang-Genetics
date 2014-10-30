class MainpgController < ApplicationController

  def index
  end

  def import
   Users.import(params[:file])
  end


end
