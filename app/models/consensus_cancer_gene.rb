class ConsensusCancerGene < ActiveRecord::Base
  has_many :mutations
  has_many :diseases, through: :mutations
 # validates :name, presence: true, uniqueness: true
 # validates :genes, presence: true
 #attr_accessor :gene_symbol, :name, :entrez_geneid, :chr, :chr_band, :somatic, :germline, :tumour_types_somatic, :tumour_types_germline, :cancer_syndrome, :tissue_type, :molecular_genetics, :mutation_types, :translocation_partner, :other_germline_mut, :other_syndrome, :synonyms
  max_paginates_per 100

 def self.import(file)
  CSV.foreach(file.path, headers: true) do |row|
    unless row[12].nil?
     row[12].gsub!(/[ADFNOST]/, 'A' => 'Amplification', 'D' => 'Deletion(Large)', 'F' => 'Frameshift', 'N' => 'Nonsense', 'O' => 'Other', 'S' => 'Splice-site', 'T' => 'Translocation')
     row[12].gsub!(/Mis/, 'Missense')
    end
    ConsensusCancerGene.new(
    :gene_symbol => row[0],
    :name => row[1],
    :entrez_geneid => row[2],
    :chr => row[3],
    :chr_band => row[4],
    :somatic => row[5],
    :germline => row[6],
    :tumour_types_somatic => row[7],
    :tumour_types_germline => row[8],
    :cancer_syndrome => row[9],
    :tissue_type => row[10],
    :molecular_genetics => row[11],
    :mutation_types => row[12],
    :translocation_partner => row[13] ,
    :other_germline_mut => row[14],
    :other_syndrome => row[15],
    :synonyms => row[16]
    ).save!
   end
 end

 def self.search(search)
  if search
   self.where("gene_symbol like ?", "%#{search}%")
  else
   self.all
  end
 end
 # def self.import(file)
 #  CSV.foreach(file.path, headers: true) do |row|
 #    ConsensusCancerGene.create! row.to_hash
 #  end
 # end
end
