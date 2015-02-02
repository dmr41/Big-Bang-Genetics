class AddcolumnToJoinTable < ActiveRecord::Migration
  def change
    add_column :mutations, :original_histology, :string
  end
end
