class Company < ApplicationRecord
  belongs_to :user

  # validaciones

  validates :name_company, presence: true
  validates :name_company, uniqueness: true
end
