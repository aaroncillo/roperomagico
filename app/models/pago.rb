# == Schema Information
#
# Table name: pagos
#
#  id                :bigint           not null, primary key
#  description_gasto :text
#  fecha_gasto       :date
#  name_gasto        :string
#  precio_gasto      :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  company_id        :bigint           not null
#
# Indexes
#
#  index_pagos_on_company_id  (company_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#
class Pago < ApplicationRecord
  belongs_to :company
end
