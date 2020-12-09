class Student < ApplicationRecord
  belongs_to :user
  validates :fullname, :departament, :group, :wish, presence: true
end
