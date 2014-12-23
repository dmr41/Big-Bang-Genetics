class Changebooleansofcancercensus < ActiveRecord::Migration
  def change
   change_column :consensus_cancer_genes, :tumour_types_somatic, :string
   change_column :consensus_cancer_genes, :tumour_types_germline, :string
  end
end
