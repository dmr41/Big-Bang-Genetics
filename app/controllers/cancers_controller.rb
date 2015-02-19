
class CancersController < ApplicationController

  def index
    @cut_off = 1
    @mutation_list = Mutation.order(:original_histology).select(:original_histology).uniq
    @mutation_test = Mutation.pluck(:original_histology).uniq.sort.reverse
    @mutation_test = @mutation_test.push("Select tumour type...").reverse
    @mut_table = Mutation.where("mutation_counter >= ?", @cut_off).pluck(:consensus_cancer_gene_id).uniq
    @mut_cnt = @mut_table.count
    if params[:search].present?
      @consensus_cancer_genes = ConsensusCancerGene.where("gene_symbol like ? OR name like ?",
      "%#{ params[:search] }%", "%#{ params[:search] }%").order(params[:gene_symbol])

      @consensus_genes_count = @consensus_cancer_genes.count
    elsif params[:original_histology] == "Select tumour type..."
      @consensus_cancer_genes = ConsensusCancerGene.where(id: @mut_table).order(params[:gene_symbol])
      @consensus_genes_count = ConsensusCancerGene.order(params[:gene_symbol]).count
    elsif params[:original_histology].present?
      @mutation_selector = Mutation.where(original_histology: params[:original_histology]).order(params[:gene_symbol])
      @holding = @mutation_selector.pluck(:consensus_cancer_gene_id).sort.uniq
      @consensus_cancer_genes = ConsensusCancerGene.where(id: @holding).order(params[:gene_symbol])
      @consensus_genes_count = @holding.count
    else
      @consensus_cancer_genes = ConsensusCancerGene.where(id: @mut_table).order(params[:gene_symbol])
      @consensus_genes_count = ConsensusCancerGene.order(params[:gene_symbol]).count
    end
  end

  def new
    @cancer = Cancer.new
  end

  def edit
    @cancer =Cancer.find(params[:id])
  end

  def count_somatic
    @som_count = 0
      if @consensus_cancer_gene.somatic == "false"
        @som_count += 1
      else
      end
  end

  def show
    if current_user
      @current_user = User.find(current_user.id)
      @current_gene_array = @current_user.my_genes
    end
    @consensus_cancer_gene = ConsensusCancerGene.find(params[:id])
    @all_gene_mutations = Mutation.where(consensus_cancer_gene_id: @consensus_cancer_gene.id).pluck(:original_histology).uniq
    @new_hist_array = []
    @all_gene_mutations.each do |gene|
      gene = gene.gsub(/_/, " ")
      @new_hist_array.push(gene)
    end
    @final_hist = @new_hist_array.join(", ")
    if params[:mutation_cut_off].present?
      @cut_off = params[:mutation_cut_off]
    else
      @cut_off = 1
    end
    @diseases = Disease.where(gene_name: @consensus_cancer_gene.gene_symbol)
    @mutation_count = Disease.where(gene_name: @consensus_cancer_gene.gene_symbol).count
    @uniq_mutation_count = Disease.where(gene_name: @consensus_cancer_gene.gene_symbol).select(:cds_mutation_syntax).map(&:cds_mutation_syntax).uniq.count
    @mutties_not_zero = @consensus_cancer_gene.mutations.where.not(nuc_position1: 0)
    @mutties_not_zero = @mutties_not_zero.where.not(nuc_position1: -100)
    @mutties_not_zero = @mutties_not_zero.where.not(nuc_change_from: nil)
    count_somatic
    @mutties = @mutties_not_zero.order('nuc_position1').where("mutation_counter >= ?", @cut_off)
    @mutties_json = @mutties.to_json
    @mutties_counter = @mutties.count
    @json_mutations = @mutties_not_zero
    @page_mutties = @mutties.where.not(nuc_position1: 0).page params[:page]
    @uniq_array = @mutties.map(&:original_mutation_string).uniq
  end

  def acs_cancer_list
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

  # def mutation_params
  #  params.require(:mutation).permit(:consensus_cancer_gene_id, :disease_id)
  # end
end
