class User < ActiveRecord::Base

  validates :email, presence: true, uniqueness: true
  validates :first_name, :last_name, :age, presence: true
  has_secure_password

end
