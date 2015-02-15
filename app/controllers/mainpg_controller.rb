class MainpgController < ApplicationController

  def index
   @consensus_genes_count = ConsensusCancerGene.all
  end

end
