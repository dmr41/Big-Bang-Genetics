class AddColumnUsers < ActiveRecord::Migration
  def change
    add_column :users, :my_genes, :integer, array: true, default: []
  end
end
