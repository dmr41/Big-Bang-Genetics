class CancersController < ApplicationController

  def index
    @cancers = Cancer.order(params[:name])
    if params[:search].present?
      @consensus_cancer_genes = ConsensusCancerGene.search(params[:search]).page params[:page]
    else
      @consensus_cancer_genes = ConsensusCancerGene.all.page params[:page]
    end
    @consensus_genes_count = ConsensusCancerGene.all
  end

  def new
    @cancer = Cancer.new
  end

  def edit
    @cancer =Cancer.find(params[:id])
  end

  def show
    @cancer = Cancer.find(params[:id])
    @consensus_cancer_gene = ConsensusCancerGene.find(params[:id])
  end

  def acs_cancer_list
  end

  # def import
  #  Cancer.delete_all
  #  if params[:file]
  #   Cancer.import(params[:file])
  #   redirect_to cancers_path, notice: "csv of Cancers imported."
  #  else
  #   redirect_to new_cancer_path, notice: "Error! Must upload cancer file."
  #  end
  # end

  def import
   ConsensusCancerGene.delete_all
     if params[:file]
      ConsensusCancerGene.import(params[:file])
       redirect_to cancers_path, notice: "csv of Cancers imported."
     else
       redirect_to new_cancer_path, notice: "Error! Must upload cancer file."
     end
  end

  def create
    Cancer.delete_all
    @disease_master = CSV.read('acs_cancers.csv')
    @disease = @disease_master[0]
    @disease = @disease[0..10]
    @disease.each do |disease|
      @cancer = Cancer.new(cancer_params)
      disease = disease.capitalize
      cancer_page = Wikipedia.find( "#{disease}" )
      cancer_name_raw = cancer_page.title
      cancer_name = cancer_name_raw.gsub(/ /, "_")
      @cancer[:name] = cancer_name_raw
      @cancer[:search_name] = cancer_name
      gene_page = Wikipedia.find("#{disease}")
      gene_name_raw = gene_page.title
      gene_name = gene_name_raw.gsub(/ /, "_")
      @cancer[:genes] = gene_name_raw
      @cancer[:gene_search_name] = gene_name
      @cancer.save
   end
      # cname = @cancer.name.capitalize
      # redirect_to cancers_path, notice: "Cancer: #{cname} - was added to the database."
    # else
      # render :new
    # end
    redirect_to cancers_path
  end

  def update
    @cancer = Cancer.find(params[:id])
    cancer_page = Wikipedia.find( "#{@cancer.name}" )
    cancer_name_raw = cancer_page.title
    cancer_name = cancer_name_raw.gsub(/ /, "_")
    @cancer[:name] = cancer_name_raw
    @cancer[:search_name] = cancer_name
    gene_page = Wikipedia.find("#{@cancer.genes}")
    gene_name_raw = gene_page.title
    gene_name = gene_name_raw.gsub(/ /, "_")
    @cancer[:genes] = gene_name_raw
    @cancer[:gene_search_name] = gene_name
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
    params.require(:cancer).permit(:name, :genes, :search_name, :gene_search_name)
  end
end
