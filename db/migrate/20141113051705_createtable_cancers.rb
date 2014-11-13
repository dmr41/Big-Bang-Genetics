class CreatetableCancers < ActiveRecord::Migration
  def change
    create_table :cancers do |t|
      t.string :name
      t.text :genes, array: true, default: []
    end
  end
end
