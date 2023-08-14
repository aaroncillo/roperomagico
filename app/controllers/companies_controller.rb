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

    filtered = Client.where(company_id: @company.id)

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

    @valor_ventas = 0
    @valor_arriendos = 0

    if params[:start_date_between]
      starts, ends = params[:start_date_between].split(" - ")
      starts_for_select = Date.strptime(starts, "%m/%d/%Y")
      ends_for_select = Date.strptime(ends, "%m/%d/%Y")

      # Cálculo de valores directamente en SQL
      @valor_ventas = Product.where(client_id: filtered.pluck(:id),
                                    init_date: starts_for_select..ends_for_select,
                                    estado: ["ENTREGADO", "VENTA"]).sum(:valor)

      @valor_arriendos = Product.where(client_id: filtered.pluck(:id),
                                       init_date: starts_for_select..ends_for_select,
                                       estado: "ARRIENDO").sum(:valor)
    end
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
