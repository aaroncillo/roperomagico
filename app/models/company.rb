# == Schema Information
#
# Table name: companies
#
#  id           :bigint           not null, primary key
#  name_company :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :bigint           not null
#
# Indexes
#
#  index_companies_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Company < ApplicationRecord
  belongs_to :user
  has_many :clients, dependent: :destroy
  has_many :products, through: :clients

  # validaciones

  validates :name_company, presence: true
  validates :name_company, uniqueness: true
end
