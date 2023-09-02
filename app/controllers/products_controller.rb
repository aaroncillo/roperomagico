class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy ]
  before_action :set_product_user, only: %i[show index edit new]
  before_action :product_params, only: %i[ create ]

  def index
    @products = Product.all
  end

  def new
    @editing = false
    @client = Client.find(params[:client_id])
    @product = Product.new
  end

  def create
    @client = Client.find(params[:client_id])
    @product = @client.products.build(product_params)
    @product = Product.new(product_params)
    @product.client = @client
    if @product.save
      redirect_to client_path(@client), notice: 'Product was successfully created.', status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @product = Product.find(params[:id])
  end

  def edit
    @editing = true
  end

  def update
    @product = Product.find(params[:id])
    @company = @product.company # Asumiendo que existe una relación entre Product y Company

    if @product.update(product_params)
      if request.referer.include?('morosos')
        redirect_to company_morosos_path(@company), notice: 'Moroso Actualizado Correctamente'
      elsif request.referer.include?('prestamos')
        redirect_to company_prestamos_path(@company), notice: 'Prestamo Actualizado Correctamente'
      elsif request.referer.include?('reservas')
        redirect_to company_reservas_path(@company), notice: 'Reserva Actualizado Correctamente'
      elsif request.referer.include?('balances')
        redirect_to company_balances_path(@company), notice: 'Cliente en Balance Actualizado Correctamente'
      else
        redirect_to client_path(@product.client), notice: 'Product was successfully updated.'
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    redirect_to client_path(@product.client), notice: 'Product was successfully destroyed.', status: :see_other
  end

  private

  def product_params
    params.require(:product).permit(:disfraz, :agregado, :valor, :garantia, :init_date, :end_date, :reserva_date, :estado)
  end

  def set_product
    @product = Product.find(params[:id])
  end

  def set_product_user
    @products = Product.where(user_id: current_user.id)
  end
end
