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


    filtered = Client.joins(:products)
    .where('products.updated_at >= ?', Time.now - 7.days)
    .where(company_id: @company.id)
    .group('clients.id')
    .order('MAX(products.updated_at) DESC')

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
    @products = []

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
                                       estado: ["ARRIENDO", "ENTREGADO", "RESERVA"]).sum(:valor)

      @valor_garantias = Product.where(client_id: filtered.pluck(:id),
      init_date: starts_for_select..ends_for_select,
      estado: ["ARRIENDO","RESERVA"]).sum(:garantia)

      @valor_pagos = Product.where(client_id: filtered.pluck(:id),
                                  init_date: starts_for_select..ends_for_select,
                                  estado: ["PAGO"]).sum(:valor)

      @valor_inversion = Product.where(client_id: filtered.pluck(:id),
                                  init_date: starts_for_select..ends_for_select,
                                  estado: ["INVERSION"]).sum(:valor)

      @total_entrada = @valor_ventas + @valor_arriendos + @valor_entregados

      @calculo = @total_entrada - @valor_pagos - @valor_inversion
      @clients = Client.where(company_id: @company.id)
      @products = Product.includes(:client).where(client: @clients, init_date: starts_for_select..ends_for_select)
    end

  end

  def graficos
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
                                       estado: ["ARRIENDO", "ENTREGADO", "RESERVA"]).sum(:valor)

      @valor_garantias = Product.where(client_id: filtered.pluck(:id),
      init_date: starts_for_select..ends_for_select,
      estado: ["ARRIENDO","RESERVA"]).sum(:garantia)

      @valor_pagos = Product.where(client_id: filtered.pluck(:id),
                                  init_date: starts_for_select..ends_for_select,
                                  estado: ["PAGO"]).sum(:valor)

      @valor_inversion = Product.where(client_id: filtered.pluck(:id),
                                  init_date: starts_for_select..ends_for_select,
                                  estado: ["INVERSION"]).sum(:valor)

      @total_entrada = @valor_ventas + @valor_arriendos + @valor_entregados

      @calculo = @total_entrada - @valor_pagos - @valor_inversion

      @ingresos_per_mes = Company.joins(:products).where(products: { init_date: starts_for_select..ends_for_select, estado: ["ARRIENDO", "ENTREGADO", "VENTA", "RESERVA"] }).group_by_month(:init_date).sum(:valor)
      @pagos_per_mes = Company.joins(:products).where(products: { init_date: starts_for_select..ends_for_select, estado: ["PAGO"] }).group_by_month(:init_date).sum(:valor)
      @inversion_per_mes = Company.joins(:products).where(products: { init_date: starts_for_select..ends_for_select, estado: ["INVERSION"] }).group_by_month(:init_date).sum(:valor)

      @diferencia_por_mes = {}

      @ingresos_per_mes.each do |month, ingresos|
      pagos = @pagos_per_mes[month] || 0
      inversiones = @inversion_per_mes[month] || 0
      @diferencia_por_mes[month] = ingresos - pagos - inversiones
      end

      @ingresos_by_day = Company.joins(:products).where(products: { init_date: starts_for_select..ends_for_select, estado: ["ARRIENDO", "ENTREGADO", "VENTA", "RESERVA"] }).group_by_day(:init_date, format: "%a").sum(:valor)
      @pagos_by_day = Company.joins(:products).where(products: { init_date: starts_for_select..ends_for_select, estado: ["PAGO"] }).group_by_day(:init_date, format: "%a").sum(:valor)
      @inversion_by_day = Company.joins(:products).where(products: { init_date: starts_for_select..ends_for_select, estado: ["INVERSION"] }).group_by_day(:init_date, format: "%a").sum(:valor)

      @diferencia_by_day = {}

      @ingresos_by_day.each do |day, ingresos|
      pagos = @pagos_by_day[day] || 0
      inversiones = @inversion_by_day[day] || 0
      @diferencia_by_day[day] = ingresos - pagos - inversiones
      end

      @ingresos_by_day2 = Company.joins(:products)
        .where(products: { init_date: starts_for_select..ends_for_select, estado: ["ARRIENDO", "ENTREGADO", "VENTA"] })
        .group(:init_date)  # Esto agrupa por día sin formato de día de la semana
        .sum(:valor)

      @pagos_by_day2 = Company.joins(:products)
        .where(products: { init_date: starts_for_select..ends_for_select, estado: ["PAGO"] })
        .group(:init_date)  # Esto agrupa por día sin formato de día de la semana
        .sum(:valor)

      @inversion_by_day2 = Company.joins(:products)
        .where(products: { init_date: starts_for_select..ends_for_select, estado: ["INVERSION"] })
        .group(:init_date)  # Esto agrupa por día sin formato de día de la semana
        .sum(:valor)

      @diferencia_by_day2 = {}

      @ingresos_by_day2.each do |day2, ingresos2|
        pagos2 = @pagos_by_day2[day2] || 0
        inversiones2 = @inversion_by_day2[day2] || 0
        @diferencia_by_day2[day2] = ingresos2 - pagos2 - inversiones2
      end

      @pie_chart_data = {
        "Ingresos" => @total_entrada,
        "Ganancias" => @calculo,
        "Sueldos" => @valor_pagos
      }

      @pie_chart_versus = {
        "Arriendos" => @valor_arriendos,
        "Ventas" => @valor_ventas
      }

      @starts_for_select = starts_for_select
      @ends_for_select = ends_for_select


      @data_by_day = Company.joins(:products)
      .where(products: { init_date: starts_for_select..ends_for_select })
      .group_by_day_of_week(:init_date, format: "%a")
      .sum("valor")

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
