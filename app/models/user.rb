class User < ApplicationRecord
  has_secure_password
  has_many :expenses, dependent: :destroy #депенд дестрой значит что при удалении юзера удаляются все его expenses
  
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
end
