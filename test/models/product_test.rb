# == Schema Information
#
# Table name: products
#
#  id         :bigint           not null, primary key
#  agregado   :text
#  disfraz    :string
#  end_date   :date
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
require "test_helper"

class ProductTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
