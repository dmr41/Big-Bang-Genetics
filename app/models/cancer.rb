class Cancer < ActiveRecord::Base

 has_many :diseases, through: :mutations
  #
  # def self.import(file)
  #     CSV.foreach(file.path, headers: true) do |row|
  #       Cancer.create! row.to_hash
  #     end
  # end

  def self.import(file)
       CSV.foreach(file.path, headers: true) do |row|
           Cancer.create! row.to_hash
        end
    end

end
