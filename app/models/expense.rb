class Expense < ApplicationRecord
  belongs_to :user #модель expense принадлежит модели user

  validates :title, :value, :spent_on, presence: true
  validates :title, length: { maximum: 16 }
  validates :title, uniqueness: true 
  validates :value, numericality: { greater_than: 0 }
  validate :spent_on_not_in_future

  private

  def spent_on_not_in_future
    return if spent_on.blank?
    errors.add(:spent_on, "can't be in the future") if spent_on > Date.today
  end
end