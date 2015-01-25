class Cancer < ActiveRecord::Base

 has_many :diseases, through: :mutations
  #
  # def self.import(file)
  #     CSV.foreach(file.path, headers: true) do |row|
  #       Cancer.create! row.to_hash
  #     end
  # end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      Cancer.create! row.to_hash
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
          @hold_original = Mutation.where(:original_mutation_string => @mutty.original_mutation_string).first
          @hold_original[:mutation_counter] = @hold_original.mutation_counter + 1
          @hold_original.save
        else
          @mutty[:mutation_counter] = 1
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


end
