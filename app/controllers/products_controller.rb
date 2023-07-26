class ProductsController < ApplicationController

  def index
    @products = Product.all
  end

  def new
    @company = Company.find(params[:company_id])
    @product = Product.new
  end

  def create
    @company = Company.find(params[:company_id])
    @product = Product.new(product_params)
    @product.company = @company
    if @product.save
      redirect_to company_path(@company)
    else
      render :new, status: :unprocessable_entity
    end
  end
end
