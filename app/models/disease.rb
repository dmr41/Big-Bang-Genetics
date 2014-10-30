class Disease < ActiveRecord::Base

  def self.import(file)
      CSV.foreach(file.path, headers: true) do |row|
        Disease.create! row.to_hash
      end
  end

end
