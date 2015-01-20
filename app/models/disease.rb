class Disease < ActiveRecord::Base
  has_many :mutations
  has_many :consensus_cancer_genes, through: :mutations


  def self.import(file)
      CSV.foreach(file.path, headers: true) do |row|
       if row[14] = "y"
        Disease.create! row.to_hash
       end
      end
  end

  def auto_import
    Disease.delete_all
    CSV.foreach("/Users/dmr/Desktop/COSMIC/master_mutation.csv", headers: true) do |row|
      if row[14] = "y"
        Disease.create! row.to_hash
      end
    end
  end

  def smart_import
    Disease.delete_all
    options = {chunk_size: 1000, keep_original_headers: true}
    SmarterCSV.process('/Users/dmr/Desktop/COSMIC/master_mutation.csv', options) do |chunk|
      chunk.each do |data_hash|
        # if data_hash["in_cancer_census"] == "y"
          Disease.create!(data_hash)
        # end
      end
    end
  end



end
