class Expense < ApplicationRecord
  validates :title, :value, :spent_on, presence: true
  validates :title, length: { maximum: 16 }
  validates :value, numericality: { greater_than: 0 }
  validates :title, uniqueness: true 
end