# == Schema Information
#
# Table name: products
#
#  id         :bigint           not null, primary key
#  agregado   :text
#  disfraz    :string
#  end_date   :date
#  estado     :string
#  garantia   :integer
#  init_date  :date
#  valor      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  client_id  :bigint           not null
#
# Indexes
#
#  index_products_on_client_id  (client_id)
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#
class Product < ApplicationRecord
  ESTADO = %w(ARRIENDO ENTREGADO VENTA)
  belongs_to :client

  #Validaciones

  validates :disfraz, :garantia, :valor, :agregado, :init_date, :end_date, :estado, presence: true
  validates :estado, inclusion: { in: ESTADO }
end
