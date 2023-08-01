class CompaniesController < ApplicationController
  before_action :set_company, only: %i[show edit update destroy]
  before_action :set_company_user, only: %i[show index edit new]

  def index
    @companies = Company.all
  end

  def new
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
    filtered = Client.where("name LIKE ?", "%#{params[:filter]}%").all
    @pagy, @clients = pagy(filtered.all, items: 5)
    @start_date_between = params[:start_date_between]

    # DatePicker

    @valor_ventas = 0
    @valor_arriendos = 0
    @valor_garantias = 0
    @ganancia = 0

    if params[:start_date_between]
      starts, ends = params[:start_date_between].split(" - ")
      starts_for_select = Date.strptime(starts, "%m/%d/%Y")
      ends_for_select = Date.strptime(ends, "%m/%d/%Y")

      # Obtenemos todos los productos relevantes en un solo paso
      relevant_products = Product.where(client_id: @clients.pluck(:id), init_date: starts_for_select..ends_for_select)

      # Calculamos los totales directamente con consultas de la base de datos
      @valor_ventas = relevant_products.where(estado: "VENTA").sum(:valor)
      @valor_arriendos = relevant_products.where(estado: ["ARRIENDO", "CASO", "RESERVA"]).sum(:valor)
      @valor_garantias = relevant_products.where(estado: "ARRIENDO").sum(:garantia)

      # Calculamos la ganancia total
      @ganancia = @valor_ventas + @valor_arriendos
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
