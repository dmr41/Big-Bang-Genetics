class CreateTable < ActiveRecord::Migration
  def change
    create_table :diseases do |t|
      t.string :input1
      t.string :input2
      t.string :input3
    end
  end
end
