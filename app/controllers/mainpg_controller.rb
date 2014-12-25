class MainpgController < ApplicationController

  def index
   @consensus_genes_count = ConsensusCancerGene.all
  end

  def import
   Users.import(params[:file])
  end


end
