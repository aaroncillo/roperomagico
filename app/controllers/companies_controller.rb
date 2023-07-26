class CompaniesController < ApplicationController
  before_action :set_company, only: %i[show edit update destroy]
  before_action :set_company_user, only: %i[show index edit new]
  before_action :company_params, only: %i[ create ]

  def index
    @companies = Company.all
  end

  def new
    @company = Company.new
  end

  def create
    @company = Company.new(company_params)
    @company.user = current_user
    if @company.save
      redirect_to companies_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @company = Company.find(params[:id])
    @client = Client.new
    @clients = Client.where(company_id: @company.id).includes(:products) # Cargar los productos asociados a los clientes de forma eficiente.

    # DatePicker

    @valor_ventas = 0
    @valor_arriendos = 0
    @valor_garantias = 0
    @ganancia = 0

    if params[:start_date_between]
      starts, ends = params[:start_date_between].split(" - ")
      starts_for_select = Date.strptime(starts, "%m/%d/%Y")
      ends_for_select = Date.strptime(ends, "%m/%d/%Y")

      @clients.each do |client|
        client.products.where(init_date: starts_for_select..ends_for_select).each do |product|
          if product.estado == "VENTA"
            @valor_ventas += product.valor
          elsif product.estado == "ARRIENDO"
            @valor_arriendos += product.valor
          end
          @valor_garantias += product.garantia
          @ganancia = @valor_ventas + @valor_arriendos
        end
      end
    else
      @clients.each do |client|
        client.products.each do |product|
          if product.estado == "VENTA"
            @valor_ventas += product.valor
          elsif product.estado == "ARRIENDO"
            @valor_arriendos += product.valor
          end
          @valor_garantias += product.garantia
          @ganancia = @valor_ventas + @valor_arriendos
        end
      end
    end
  end

  def edit
  end

  def update
    if @company.update(company_params)
      redirect_to companies_path, notice: 'Company was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @company.destroy
    redirect_to companies_path, notice: 'Company was successfully destroyed.', status: :see_other
  end

  private

  def company_params
    params.require(:company).permit(:name_company)
  end

  def set_company
    @company = Company.find(params[:id])
  end

  def set_company_user
    @companies = Company.where(user_id: current_user.id)
  end
end
