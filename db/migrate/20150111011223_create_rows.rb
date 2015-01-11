class CreateRows < ActiveRecord::Migration
  def change
    add_column :mutations, :nuc_position1, :integer
    add_column :mutations, :nuc_position2, :integer
    add_column :mutations, :ins_del_single, :string
    add_column :mutations, :nuc_change_from, :string
    add_column :mutations, :nuc_change_to, :string
  end
end
