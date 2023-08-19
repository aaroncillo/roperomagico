# == Schema Information
#
# Table name: gastos
#
#  id                 :bigint           not null, primary key
#  description_gastos :text
#  name_gastos        :string
#  precio_gastos      :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  company_id         :bigint           not null
#
# Indexes
#
#  index_gastos_on_company_id  (company_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#
class Gasto < ApplicationRecord
  belongs_to :company
end
