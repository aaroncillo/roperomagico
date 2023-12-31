# == Schema Information
#
# Table name: companies
#
#  id           :integer          not null, primary key
#  name_company :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :integer          not null
#
# Indexes
#
#  index_companies_on_user_id  (user_id)
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#
class Company < ApplicationRecord
  belongs_to :user
  has_many :clients, dependent: :destroy
  has_many :products, through: :clients
  has_many :pagos, dependent: :destroy
  has_many :inversions, dependent: :destroy

  # validaciones

  validates :name_company, presence: true
  validates :name_company, uniqueness: true

  scope :having_dob_between, ->(start_date, end_date) { where(dob: start_date..end_date) }
end
