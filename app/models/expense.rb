class Expense < ApplicationRecord
  validates :title, :value, :spent_on, presence: true
  validates :title, length: { maximum: 16 }
  validates :value, numericality: { greater_than: 0 }
  validates :title, uniqueness: true 
  validate :spent_on_not_in_future

  private

  def spent_on_not_in_future
    return if spent_on.blank?
    errors.add(:spent_on, "cant be in the future") if spent_on > Date.today
  end
end