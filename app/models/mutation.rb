class Mutation < ActiveRecord::Base

  belongs_to :consensus_cancer_gene
  belongs_to :disease
  scope :unique_histology, lambda { select(:original_histology, :id).uniq}

end
