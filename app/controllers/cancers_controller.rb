require 'capybara'

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
    @thong = [{
        "letter"=> "AA",
        "frequency"=> 1
      },
      {
        "letter"=> "AB",
        "frequency"=> 2
      },
      {
        "letter"=> "AC",
        "frequency"=> 3
      },
      {
        "letter"=> "AD",
        "frequency"=> 4
      },
      {
        "letter"=> "AE",
        "frequency"=> 5
      },
      {
        "letter"=> "AF",
        "frequency"=> 6
      },
      {
        "letter"=> "AG",
        "frequency"=> 7
      },
      {
        "letter"=> "AH",
        "frequency"=> 8
      },
      {
        "letter"=> "AI",
        "frequency"=> 10
      },
      {
        "letter"=> "AJ",
        "frequency"=> 11
      },
      {
        "letter"=> "AK",
        "frequency"=> 12
      },
      {
        "letter"=> "AL",
        "frequency"=> 16
      },
      {
        "letter"=> "AM",
        "frequency"=> 4
      },
      {
        "letter"=> "AN",
        "frequency"=> 20
      },
      {
        "letter"=> "AO",
        "frequency"=> 17
      },
      {
        "letter"=> "AP",
        "frequency"=> 13
      },
      {
        "letter"=> "AQ",
        "frequency"=> 9
      }]
    @consensus_cancer_gene = ConsensusCancerGene.find(params[:id])
    @diseases = Disease.where(gene_name: @consensus_cancer_gene.gene_symbol)
    # @uniq_mutations = Kaminari.paginate_array(@uniq_mutations).page (params[:page])
    #
    @mutation_count = Disease.where(gene_name: @consensus_cancer_gene.gene_symbol).count
    @uniq_mutation_count = Disease.where(gene_name: @consensus_cancer_gene.gene_symbol).select(:cds_mutation_syntax).map(&:cds_mutation_syntax).uniq.count
    @mutties = @consensus_cancer_gene.mutations.order('nuc_position1')
    @page_mutties = @mutties.where.not(nuc_position1: 0).page params[:page]
    @uniq_array = @mutties.map(&:original_mutation_string).uniq
    # @uniq_mutations = Kaminari.paginate_array(@mutties.map(&:original_mutation_string).uniq).page (params[:page])
  end
#postgres promote heroku
#store file on s3 and write rake task to import it to heroku Or provide api and run locally.
#increaes dyno count---- 50
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
    if params[:file]
      ConsensusCancerGene.delete_all
      CancerImporter.new(params[:file]).import
      ConsensusCancerGene.import(params[:file])
      mutations_join_table
      redirect_to cancers_path, notice: "COSMIC Consensus Cancer Genes successfully imported."
    else
      redirect_to new_cancer_path, notice: "File not found!"
    end
  end

  def mutations_join_table
    Mutation.delete_all
    @consensus_cancer_genes = ConsensusCancerGene.all
    @consensus_cancer_genes.each do |consensus_cancer_gene|
      @diseases = Disease.where(gene_name: consensus_cancer_gene.gene_symbol)
      @diseases.each do |disease|
        @mutty = Mutation.new
        @mutty[:consensus_cancer_gene_id] = consensus_cancer_gene.id
        @mutty[:disease_id] = disease.id
        @mutty[:original_mutation_string] = disease.cds_mutation_syntax
        @allele = disease.cds_mutation_syntax
        remove_beginning_allele
        if @allele.include?("?") && @allele.length == 1 || @allele.include?("?_?")
          @mutty[:nuc_position1] = 0
          @mutty[:nuc_position2] = 0
          @mutty[:ins_del_single] = "unknown"
          @mutty[:nuc_change_from] = "unknown"
          @mutty[:nuc_change_to] = "unknown"
        elsif @allele.include?("_?del")
          @mutty[:ins_del_single] = "deletion"
          @split_allele = @allele.gsub(/del/,'_').split('_')
          @mutty[:nuc_position1] = @split_allele[0].to_i
          @mutty[:nuc_position2] = @split_allele[0].to_i
          @mutty[:nuc_change_from] = @split_allele[2]
          if @split_allele[2].to_i != 0 || @split_allele[2] == "?"
            @mutty[:nuc_change_to] = "unknown"
          else
            @mutty[:nuc_change_to] = "-"
          end
        elsif @allele.include?("_?ins")
          @mutty[:ins_del_single] = "insertion"
          @split_allele = @allele.gsub(/ins/,'_').split('_')
          @mutty[:nuc_position1] = @split_allele[0].to_i
          @mutty[:nuc_position2] = @split_allele[0].to_i
          @mutty[:nuc_change_from] = "-"
          if @split_allele[2].to_i != 0 || @split_allele[2] == "?"
            @mutty[:nuc_change_to] = "unknown"
          else
           @mutty[:nuc_change_to] = @split_allele[2]
          end
        elsif @allele.include?("del") && @allele.include?("_")
          @mutty[:ins_del_single] = "deletion"
          @split_allele = @allele.gsub(/del/,'_').split('_')
          @mutty[:nuc_position1] = @split_allele[0].to_i
          @mutty[:nuc_position2] = @split_allele[1].to_i
          @mutty[:nuc_change_from] = @split_allele[2]
          if @split_allele[2].to_i != 0 || @split_allele[2] == "?"
            @mutty[:nuc_change_to] = "unknown"
          else
            @mutty[:nuc_change_to] = "-"
          end
        elsif @allele.include?("ins") && @allele.include?("_")
          @mutty[:ins_del_single] = "insertion"
          @split_allele = @allele.gsub(/ins/,'_').split('_')
          @mutty[:nuc_position1] = @split_allele[0].to_i
          @mutty[:nuc_position2] = @split_allele[1].to_i
          @mutty[:nuc_change_from] = "-"
          if @split_allele[2].to_i != 0 || @split_allele[2] == "?"
            @mutty[:nuc_change_to] = "unknown"
          else
            @mutty[:nuc_change_to] = @split_allele[2]
          end
        elsif @allele.include?("del")
          @mutty[:ins_del_single] = "deletion"
          @split_allele = @allele.gsub(/del/,'_').split('_')
          @mutty[:nuc_position1] = @split_allele[0].to_i
          @mutty[:nuc_position2] = @split_allele[0].to_i
          @mutty[:nuc_change_from] = @split_allele[1]
          if @split_allele[1].to_i != 0 || @split_allele[1] == "?"
            @mutty[:nuc_change_to] = "unknown"
          else
            @mutty[:nuc_change_to] = "-"
          end
        elsif @allele.include?("ins")
          @mutty[:ins_del_single] = "insertion"
          @split_allele = @allele.gsub(/ins/,'_').split('_')
          @mutty[:nuc_position1] = @split_allele[0].to_i
          @mutty[:nuc_position2] = @split_allele[0].to_i
          @mutty[:nuc_change_from] = "-"
          if @split_allele[1].to_i != 0 || @split_allele[1] == "?"
            @mutty[:nuc_change_to] = "unknown"
          else
            @mutty[:nuc_change_to] = @split_allele[1]
          end
        elsif @allele.include?(">") && (@allele.include?("+") || @allele.include?("-") || @allele.include?("_"))
          @split_allele = @allele.gsub(/[>_+-]/, '_').split('_')
          @middle_value = @split_allele[1]
          @second_position = @middle_value.gsub(/[ACTG]/,'')
          @unmutated_seq = @middle_value.gsub(/["#{@second_position}"]/, '')
          if @allele.include?("+")
            @mutty[:ins_del_single] = "splice site"
            @mutty[:nuc_position2] = @second_position.to_i
          elsif @allele.include?("-")
            @mutty[:ins_del_single] = "intronic"
            @mutty[:nuc_position2] = @second_position.to_i
          elsif @allele.include?("_")
            @mutty[:ins_del_single] = "standard"
            @mutty[:nuc_position2] = @second_position.to_i
          end
          @mutty[:nuc_position1] = @split_allele[0].to_i
          @mutty[:nuc_change_from] = @unmutated_seq
          if @split_allele[2].to_i != 0 || @split_allele[2] == "?"
            @mutty[:nuc_change_to] = "unknown"
          else
            @mutty[:nuc_change_to] = @split_allele[2]
          end
        elsif @allele.include?(">")
          @split_allele = @allele.split('>')
          @middle_value = @split_allele[0]
          @first_position = @middle_value.gsub(/[ACTG]/,'')
          @unmutated_seq = @middle_value.gsub(/["#{@first_position}"]/, '')
          @mutty[:nuc_position1] = @first_position.to_i
          @mutty[:nuc_position2] = @first_position.to_i
          @mutty[:ins_del_single] = "standard"
          @mutty[:nuc_change_from] = @unmutated_seq
          @mutty[:nuc_change_to] = @split_allele[1]
        else
          @mutty[:nuc_position1] = -100
          @mutty[:nuc_position2] = -100
          @mutty[:ins_del_single] = "UNCHANGED"
          @mutty[:nuc_change_from] = "UNCHANGED"
          @mutty[:nuc_change_to] = "UNCHANGED"
        end
        if Mutation.where(:original_mutation_string => @mutty.original_mutation_string).exists?
        else
          @mutty.save
        end
      end
    end
  end

  def remove_beginning_allele
    if @allele == nil
       @allele = ''
    else
      @allele.gsub!(/c\./, '')
      @allele.gsub!(/\)_/, '')
      @allele.gsub!(/\)/, '')
      @allele.gsub!(/\(/, '')
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

  # def mutation_params
  #  params.require(:mutation).permit(:consensus_cancer_gene_id, :disease_id)
  # end
end
