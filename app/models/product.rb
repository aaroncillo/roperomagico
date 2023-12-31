# == Schema Information
#
# Table name: products
#
#  id           :integer          not null, primary key
#  agregado     :text
#  disfraz      :string
#  end_date     :date
#  estado       :string
#  garantia     :integer
#  init_date    :date
#  reserva_date :date
#  valor        :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  client_id    :integer          not null
#
# Indexes
#
#  index_products_on_client_id  (client_id)
#
# Foreign Keys
#
#  client_id  (client_id => clients.id)
#
class Product < ApplicationRecord
  ESTADO = %w(ARRIENDO ENTREGADO VENTA PRESTAMO RESERVA PAGO INVERSION)
  belongs_to :client
  has_one :company, through: :client
  #Validaciones

end
