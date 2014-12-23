class Addcolumntocancers < ActiveRecord::Migration
  def change
    add_column :cancers, :search_name, :string
  end
end
