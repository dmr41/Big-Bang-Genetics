class Cancergenescreatetable < ActiveRecord::Migration
  def change
   create_table :consensus_cancer_genes do |t|
    t.string :gene_symbol
    t.string :name
    t.string :entrez_geneid
    t.string :chr
    t.string :chr_band
    t.string :somatic
    t.string :germline
    t.boolean :tumour_types_somatic, default: false
    t.boolean :tumour_types_germline, default: false
    t.string :cancer_syndrome
    t.string :tissue_type
    t.string :molecular_genetics
    t.string :mutation_types
    t.string :translocation_partner
    t.string :other_germline_mut
    t.string :other_syndrome
    t.string :synonyms
   end
  end
end
