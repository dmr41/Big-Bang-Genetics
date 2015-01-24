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

  # def smart_import
  def self.import(file)
    Disease.delete_all
    file = file.path
    options = {chunk_size: 100000, keep_original_headers: true}
    log_counter = 0
    SmarterCSV.process(file, options) do |chunk|
      chunk.each do |data_hash|
        # if data_hash["in_cancer_census"] == "y"
          Disease.create!(data_hash)
        # end
      end
      log_counter +=100000
      puts "---------------#{log_counter}--------------------"
    end
  end



end
