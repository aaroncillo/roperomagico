# == Schema Information
#
# Table name: inversions
#
#  id                    :bigint           not null, primary key
#  description_inversion :text
#  fecha_inversion       :date
#  name_inversion        :string
#  precio_inversion      :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  company_id            :bigint           not null
#
# Indexes
#
#  index_inversions_on_company_id  (company_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#
class Inversion < ApplicationRecord
  belongs_to :company
end
