class MutationJoinTable < ActiveRecord::Migration
 def change
  create_table :mutations do |t|
   t.belongs_to :consensus_cancer_gene
   t.belongs_to :disease
   t.timestamps
  end
 end
end
