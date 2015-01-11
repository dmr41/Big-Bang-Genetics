class Disease < ActiveRecord::Base

  has_many :mutations
  has_many :consensus_cacner_genes, through: :mutations

  def self.import(file)
      CSV.foreach(file.path, headers: true) do |row|
       if row[14] = "y"
        Disease.create! row.to_hash
       end
      end
  end

end
