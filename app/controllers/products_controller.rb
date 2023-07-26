class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy ]
  before_action :set_product_user, only: %i[show index edit new]
  before_action :product_params, only: %i[ create ]

  def index
    @products = Product.all
  end

  def new
    @client = Client.find(params[:client_id])
    @product = Product.new
  end

  def create
    @client = Client.find(params[:client_id])
    @product = Product.new(product_params)
    @product.client = @client
    if @product.save
      redirect_to client_path(@client)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @product = Product.find(params[:id])
  end

  def edit
  end

  def update
    if @product.update(product_params)
      redirect_to client_path(@product.client), notice: 'Product was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    redirect_to client_path(@product), notice: 'Product was successfully destroyed.', status: :see_other
  end

  private

  def product_params
    params.require(:product).permit(:disfraz, :agregado, :valor, :garantia, :init_date, :end_date, :estado)
  end

  def set_product
    @product = Product.find(params[:id])
  end

  def set_product_user
    @products = Product.where(user_id: current_user.id)
  end
end
