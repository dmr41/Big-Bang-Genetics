class CancerImporter

  def amino_terminal_deletions
    @nterm = Mutation.all
  end

  def mutations_join_table
    Mutation.delete_all
    @consensus_cancer_genes = ConsensusCancerGene.all
    gene_counter = 0
    @consensus_cancer_genes.each do |consensus_cancer_gene|
      gene_counter +=1
      @current_cancer_gene = consensus_cancer_gene
      puts "Gene: #{gene_counter.to_s} -> #{@current_cancer_gene.gene_symbol}"
      @diseases = Disease.where(gene_name: @current_cancer_gene.gene_symbol)
      per_disease_mutation_finder
    end
  end

  def per_disease_mutation_finder
    @diseases.each do |disease|
      @current_disease = disease
      new_mutation_table_core_ids
      remove_beginning_allele
      if @allele.include?("?") && @allele.length == 1 || @allele.include?("?_?")
        empty_nucleotide_position_data
      elsif @allele.include?("_?del")
        end_nucleotide_position_unknown_for_deletion
      elsif @allele.include?("_?ins")
        end_nucleotide_position_unknown_for_deletion
      elsif @allele.include?("del") && @allele.include?("_")
        simple_deletion
      elsif @allele.include?("ins") && @allele.include?("_")
        simple_insertion
      elsif @allele.include?("del")
        deletion_no_endpoint_specified
      elsif @allele.include?("ins")
        insertion_no_endpoint_specified
      elsif @allele.include?(">") && (@allele.include?("+") || @allele.include?("-") || @allele.include?("_"))
        splice_site_and_intronic_mutations_plus_edge_case_std_mutations
      elsif @allele.include?(">")
        standard_mutation
      else
        stray_mutation_no_seq
      end
      mutation_hit_counter
    end
  end

  def new_mutation_table_core_ids
    @mutty = Mutation.new
    @mutty[:consensus_cancer_gene_id] = @current_cancer_gene.id
    @mutty[:disease_id] =  @current_disease.id
    @mutty[:original_mutation_string] = @current_disease.cds_mutation_syntax
    @mutty[:original_histology] = [@current_disease.primary_histology]
    @allele = @current_disease.cds_mutation_syntax
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

####Begin conditionals for per_disease_mutation_finder below #####
  def mutation_hit_counter
    current_mutation = Mutation.where(:original_mutation_string => @mutty.original_mutation_string)
    if current_mutation.exists?
      @hold_original = current_mutation.first
      # @mutty[:original_histology].push()
      @hold_original[:mutation_counter] = @hold_original.mutation_counter + 1
      @hold_original.save
    else

      @mutty[:mutation_counter] = 1
      @mutty.save
    end
  end

  def empty_nucleotide_position_data
    @mutty[:nuc_position1] = 0
    @mutty[:nuc_position2] = 0
    @mutty[:ins_del_single] = "unknown"
    @mutty[:nuc_change_from] = "unknown"
    @mutty[:nuc_change_to] = "unknown"
  end

  def end_nucleotide_position_unknown_for_deletion
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
  end

  def end_nucleotide_position_unknown_for_insertion
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
  end

  def simple_deletion
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
  end

  def simple_insertion
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
  end

  def deletion_no_endpoint_specified
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
  end

  def insertion_no_endpoint_specified
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
  end

  def splice_site_and_intronic_mutations_plus_edge_case_std_mutations
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
  end

  def standard_mutation
    @split_allele = @allele.split('>')
    @middle_value = @split_allele[0]
    @first_position = @middle_value.gsub(/[ACTG]/,'')
    @unmutated_seq = @middle_value.gsub(/["#{@first_position}"]/, '')
    @mutty[:nuc_position1] = @first_position.to_i
    @mutty[:nuc_position2] = @first_position.to_i
    @mutty[:ins_del_single] = "standard"
    @mutty[:nuc_change_from] = @unmutated_seq
    @mutty[:nuc_change_to] = @split_allele[1]
  end

  def stray_mutation_no_seq
    @mutty[:nuc_position1] = -100
    @mutty[:nuc_position2] = -100
    @mutty[:ins_del_single] = "UNCHANGED"
    @mutty[:nuc_change_from] = "UNCHANGED"
    @mutty[:nuc_change_to] = "UNCHANGED"
  end
####End conditionals for per_disease_mutation_finder#####
end
