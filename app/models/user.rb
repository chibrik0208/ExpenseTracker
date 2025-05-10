class User < ApplicationRecord
  has_secure_password
  has_many :expenses, depent: :destroy
  
  validates :email, :presence true, :uniqueness true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, lenght: { minimum: 6 }, if: -> { new_record? || !password.nil? }
end
