class Cancer < ActiveRecord::Base

  validates :name, presence: true, uniqueness: true
  validates :genes, presence: true

  def self.import(file)
      CSV.foreach(file.path, headers: true) do |row|
        Cancer.create! row.to_hash
      end
  end

end
