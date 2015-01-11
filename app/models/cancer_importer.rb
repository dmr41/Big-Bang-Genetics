class CancerImporter

  def initialize(file)
    @file = file
  end

  def import
    Mutation.delete_all
    ConsensusCancerGene.delete_all
    @consensus_cancer_genes = ConsensusCancerGene.all
    @consensus_cancer_genes.each do |consensus_cancer_gene|
      @diseases = Disease.where(gene_name: consensus_cancer_gene.gene_symbol)
      @diseases.each do |disease|
        @mutty = Mutation.new
        @mutty[:consensus_cancer_gene_id] = consensus_cancer_gene.id
        @mutty[:disease_id] = disease.id
        @mutty.save
      end
    end
  end
end
