class CreateTableMoes < ActiveRecord::Migration
  def change
    create_table :moes do |t|
      t.string :honey
      t.integer :loot
    end
  end
end
