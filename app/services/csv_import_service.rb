class CsvImportService

  require 'csv'

  def initialize(file, user)
    @file = file
    @user = user
    @company = @user.companies.first
    @count = 0
  end

  def import
    @count = 0
    CSV.foreach(@file.path, headers: true) do |row|

      # C
      # create a new client
      client = Client.new
      client.name = row["cliente"]
      client.address = row["direccion"]
      client.phone = row["celular"]
      client.company = @company
      client.save!

      # @count += 1

      client_name = row["cliente"]

      # Find the client by name
      client = Client.find_by(name: client_name)

      # Create a new product
      product = Product.new
      product.disfraz = row["disfraz"]
      product.agregado = row["agregado"]
      product.valor = row["valor"]
      product.garantia = row["garantia"]
      product.init_date = row["fechaa"]
      product.end_date = row["fechad"]
      product.estado = row["estado"]

      # Associate the product with the client
      product.client = client

      # Save the product
      product.save!

      @count += 1
    end
  end

  def number_imported_with_last_run
    @count
  end

end
