# == Schema Information
#
# Table name: clients
#
#  id         :integer          not null, primary key
#  address    :text
#  name       :string
#  phone      :string
#  rut        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  company_id :integer          not null
#
# Indexes
#
#  index_clients_on_company_id  (company_id)
#
# Foreign Keys
#
#  company_id  (company_id => companies.id)
#
class Client < ApplicationRecord
  belongs_to :company
  has_many :products, dependent: :destroy

  # rut unico
end
