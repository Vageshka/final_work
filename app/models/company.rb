class Company < ApplicationRecord
  belongs_to :user
  validates :name, :vacancy, :requirements, :conditions, presence: true
end
