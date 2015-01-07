class DiseasesController < ApplicationController
  before_action :set_disease, only: [:show, :edit, :update, :destroy]

  def set_disease
    @disease = Disease.find(params[:id])
  end

  def index
    # @diseases = Disease.all
    @diseases = Disease.all.page params[:page]
  end

  def import
     Disease.delete_all
     if params[:file]
       Disease.import(params[:file])
       redirect_to diseases_path, notice: "csv imported."
     else
       redirect_to diseases_path, notice: "Error! Must upload file."
     end
  end

  def create
    @disease = Disease.new(disease_params)
    respond_to do |format|
      if @disease.save
        format.html { redirect_to diseases_path, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @disease }
      else
        format.html { render :new }
        format.json { render json: @disease.errors, status: :unprocessable_entity }
      end
    end
  end

  def disease_params
    params.require(:disease).permit(:input1, :input2, :input3)
  end

end
