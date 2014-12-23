class Createtable < ActiveRecord::Migration
  def change
    remove_column :diseases, :input1
    remove_column :diseases, :input2
    remove_column :diseases, :input3
    add_column :diseases, :cosmic_sample_id, :integer
    add_column :diseases, :sample_name, :string
    add_column :diseases, :sample_source, :string
    add_column :diseases, :tumour_source, :string
    add_column :diseases, :gene_name, :string
    add_column :diseases, :accession_number, :string
    add_column :diseases, :cosmic_mutation_id, :integer
    add_column :diseases, :cds_mutation_syntax, :string
    add_column :diseases, :aa_mutation_syntax, :string
    add_column :diseases, :zygosity, :string
    add_column :diseases, :primary_site, :string
    add_column :diseases, :primary_histology, :string
    add_column :diseases, :pubmed_id, :integer
    add_column :diseases, :gene_id, :integer
    add_column :diseases, :in_cancer_census, :string
  end
end
