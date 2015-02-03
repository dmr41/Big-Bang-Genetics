mappings = {
  '?_?' => ->(row){ puts row },
  '??' => ->(row){ puts "first" },
  '__' => ->(row){ puts "first" },
}

foo = "asdfasdf  ?_? asdfasdfasdf"
f = mappings.detect do |key, value|
  foo.include?(key)
end

p f.last.call("w00t!")

#----------------

class Foo1
  def self.matches?(ob)
    ob == 'foo'
  end

  def run(thing)
  end
end

class Foo2
  def self.matches?(ob)
    ob == 'bar'
  end

  def run(thing)
  end
end

class Foo3
  def self.matches?(ob)
    ob == 'bar'
  end

  def get_attributes
    {
      foo: 'bar'
    }
  end
end

klass = [Foo1, Foo2, Foo3].detect{|k| k.matches?(input) }
klass.new(input).run


def index
  @mutation_list = Mutation.order(:original_histology).select(:original_histology).uniq
  @mutation_test= Mutation.pluck(:original_histology).uniq.sort
  @mut_table = Mutation.where("mutation_counter >= ?", @cut_off).pluck(:consensus_cancer_gene_id).uniq
  @mut_cnt = @mut_table.count
  @consensus_cancer_genes = ConsensusCancerGene.where(id: @mut_table).order(params[:gene_symbol])

#   if params[:search].present?
#     @consensus_cancer_genes = ConsensusCancerGene.where(id: @mut_table).search(params[:search]).order(params[:gene_symbol])
#   # elsif params[:original_histology].present?
#   #   @mutation_selector = Mutation.where(original_histology: params[:original_histology]).order(params[:gene_symbol])
#   #   @holding = @mutation_selector.pluck(:consensus_cancer_gene_id).sort.uniq# elsif params[:original_histology]
#   #   @consensus_cancer_genes = ConsensusCancerGene.where(id: @holding).order(params[:gene_symbol])
#   #   params[:original_histology] = nil
# elsif params[:search] == ""
#     @consensus_cancer_genes = ConsensusCancerGene.where(id: @mut_table).order(params[:gene_symbol])
#   end
  @consensus_genes_count = ConsensusCancerGene.order(params[:gene_symbol])
end
