class Addcolumnmutation < ActiveRecord::Migration
  def change
    add_column :mutations, :mutation_counter, :integer
  end
end
