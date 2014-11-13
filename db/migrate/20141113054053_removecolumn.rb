class Removecolumn < ActiveRecord::Migration
  def change
    remove_column :cancers, :genes
    add_column :cancers, :genes, :string
  end
end
