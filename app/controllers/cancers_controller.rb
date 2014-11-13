class CancersController < ApplicationController

  def index
    @cancers = Cancer.all
  end

  def new
    @cancer = Cancer.new
  end

  def edit
    @cancer =Cancer.find(params[:id])
  end

  def show
    @cancer = Cancer.find(params[:id])
  end

  def import
     Cancer.delete_all
     if params[:file]
       Cancer.import(params[:file])
       redirect_to cancers_path, notice: "csv of Cancers imported."
     else
       redirect_to new_cancer_path, notice: "Error! Must upload cancer file."
     end
  end

  def create
    @cancer = Cancer.new(cancer_params)
    if @cancer.save
      cname = @cancer.name.capitalize
      redirect_to cancers_path, notice: "Cancer: #{cname} - was added to the database."
    else
      render :new
    end
  end

  def update
    @cancer = Cancer.find(params[:id])
    if @cancer.update(cancer_params)
      cname = @cancer.name.capitalize
      redirect_to @cancer, notice: "Cancer: #{cname} - was updated."
    else
      render :edit
    end
  end

  def destroy
    @cancer = Cancer.find(parms[:id])
    cname = @cancer.name.capitalize
    @cancer.destroy
    redirect_to cancers_path, notice: "Cancer: #{cname} - was deleted from the database"
  end

  private

  def cancer_params
    params.require(:cancer).permit(:name, :genes)
  end
end
