class RemoveTable < ActiveRecord::Migration
  def change
    drop_table :moes
  end
end
