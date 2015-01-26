class Addusers < ActiveRecord::Migration
  def change
    create_table "users", force: true do |t|
      t.string  "first_name"
      t.string  "last_name"
      t.integer "age"
      t.string  "email"
      t.string  "password_digest"
    end
  end
end
