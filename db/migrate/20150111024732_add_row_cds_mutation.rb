class AddRowCdsMutation < ActiveRecord::Migration
  def change
    add_column :mutations, :original_mutation_string, :string
  end
end
