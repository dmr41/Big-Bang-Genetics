class Mutation < ActiveRecord::Base

  belongs_to :consensus_cancer_gene
  belongs_to :disease
  
end
