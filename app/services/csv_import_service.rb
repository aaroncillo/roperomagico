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
    clientes_existentes = {} # Mantener un seguimiento de los clientes existentes

    CSV.foreach(@file.path, headers: true) do |row|
      nombre_cliente = row["cliente"]

      # Verificar si el cliente ya existe
      if clientes_existentes.key?(nombre_cliente)
        cliente = clientes_existentes[nombre_cliente]
      else
        # Crear un nuevo cliente si no existe
        cliente = Client.new
        cliente.name = nombre_cliente
        cliente.address = row["direccion"]
        cliente.phone = row["celular"]
        cliente.company = @company
        cliente.save!

        clientes_existentes[nombre_cliente] = cliente
      end

      # Crear un nuevo producto
      producto = Product.new
      producto.disfraz = row["disfraz"]
      producto.agregado = row["agregado"]
      producto.valor = row["valor"]
      producto.garantia = row["garantia"]
      producto.init_date = row["fechaa"]
      producto.end_date = row["fechad"]
      producto.reserva_date = row["fechareserva"]
      producto.estado = row["estado"]

      # Asociar el producto con el cliente
      producto.client = cliente

      # Guardar el producto
      producto.save!

      @count += 1
    end
  end

  def number_imported_with_last_run
    @count
  end
end
