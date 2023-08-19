class CompaniesController < ApplicationController
  before_action :set_company, only: %i[show edit update destroy]
  before_action :set_company_user, only: %i[show index edit new]

  def index
    @companies = Company.all
  end

  def new
    @editing = false
    @company = Company.new
  end

  def create
    @company = Company.new(company_params)
    @company.user = current_user
    respond_to do |format|
      if @company.save
        format.turbo_stream { render turbo_stream: turbo_stream.prepend('companies', partial: 'companies/company', locals: {company: @company}) }
        format.html { redirect_to companies_path, notice: "Post was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity}
      end
    end
  end

  def show
    @company = Company.find(params[:id])
    @client = Client.new


    filtered = Client.where(company_id: @company.id).order(id: :desc)

    if params[:filter].present?
      filtered = filtered.where("name ILIKE ?", "%#{params[:filter]}%")
    end

    if params[:phone_filter].present?
      filtered = filtered.where("phone ILIKE ?", "%#{params[:phone_filter]}%")
    end

    if params[:rut_filter].present?
      filtered = filtered.where("rut ILIKE ?", "%#{params[:rut_filter]}%")
    end

    @pagy, @clients = pagy(filtered.all, items: 5)
  end

  def balances
    @company = Company.find(params[:company_id])
    @client = Client.new
    filtered = Client.where(company_id: @company.id).includes(:products).where("name LIKE ?", "%#{params[:filter]}%").all

    # DatePicker

    # VALORES DE PRODUCTOS
    @valor_ventas = 0
    @valor_arriendos = 0
    @valor_garantias = 0
    @valor_entregados = 0
    @total_entrada = 0

    # VALORES DE PAGOS E INVERSION

    @valor_pagos = 0
    @valor_inversion = 0
    @calculo = 0

    if params[:start_date_between]
      starts, ends = params[:start_date_between].split(" - ")
      starts_for_select = Date.strptime(starts, "%m/%d/%Y")
      ends_for_select = Date.strptime(ends, "%m/%d/%Y")

      # Cálculo de valores directamente en SQL
      @valor_ventas = Product.where(client_id: filtered.pluck(:id),
                                    init_date: starts_for_select..ends_for_select,
                                    estado: ["VENTA"]).sum(:valor)

      @valor_arriendos = Product.where(client_id: filtered.pluck(:id),
                                       init_date: starts_for_select..ends_for_select,
                                       estado: ["ARRIENDO", "ENTREGADO"]).sum(:valor)

      @valor_garantias = Product.where(client_id: filtered.pluck(:id),
      init_date: starts_for_select..ends_for_select,
      estado: ["ARRIENDO","RESERVA"]).sum(:garantia)

      @valor_pagos = Pago.where(company_id: @company.id,
      fecha_gasto: starts_for_select..ends_for_select).sum(:precio_gasto)

      @valor_inversion = Inversion.where(company_id: @company.id,
      fecha_inversion: starts_for_select..ends_for_select).sum(:precio_inversion)

      @total_entrada = @valor_ventas + @valor_arriendos + @valor_entregados

      @calculo = @total_entrada - @valor_pagos - @valor_inversion
    end
  end

  def morosos
    @company = Company.find(params[:company_id])
    filtered = Product.where('end_date < ?', Date.today).where.not(estado: ['ENTREGADO', 'VENTA'])
    @pagy, @products = pagy(filtered, items: 5)
    @morosos_by_client = @products.group_by { |p| p.client }
  end

  def prestamos
    @company = Company.find(params[:company_id])
    filtered = Product.where(estado: 'PRESTAMO').order(id: :asc)
    @pagy, @products = pagy(filtered.all, items: 5)
  end

  def reservas
    @company = Company.find(params[:company_id])
    filtered = Product.where(estado: 'RESERVA').order(id: :asc)
    @pagy, @products = pagy(filtered.all, items: 5)
  end

  def edit
    @editing = true
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
