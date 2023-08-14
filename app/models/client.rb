# == Schema Information
#
# Table name: clients
#
#  id         :bigint           not null, primary key
#  address    :text
#  name       :string
#  phone      :string
#  rut        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  company_id :bigint           not null
#
# Indexes
#
#  index_clients_on_company_id  (company_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#
class Client < ApplicationRecord
  belongs_to :company
  has_many :products, dependent: :destroy

end
