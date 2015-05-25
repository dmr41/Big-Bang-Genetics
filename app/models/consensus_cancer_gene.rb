om class ConsensusCancerGene < ActiveRecord::Base

  has_many :mutations
  has_many :diseases, through: :mutations
 # validates :name, presence: true, uniqueness: true
 # validates :genes, presence: true
 #attr_accessor :gene_symbol, :name, :entrez_geneid, :chr, :chr_band, :somatic, :germline, :tumour_types_somatic, :tumour_types_germline, :cancer_syndrome, :tissue_type, :molecular_genetics, :mutation_types, :translocation_partner, :other_germline_mut, :other_syndrome, :synonyms
  max_paginates_per 100

  def self.search(search)
    if search
     self.where("gene_symbol like ?", "%#{search}%")
    else
     self.all
    end
  end
end
