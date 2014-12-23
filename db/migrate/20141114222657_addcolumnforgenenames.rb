class Addcolumnforgenenames < ActiveRecord::Migration
  def change
    add_column :cancers, :gene_search_name, :string
  end
end
