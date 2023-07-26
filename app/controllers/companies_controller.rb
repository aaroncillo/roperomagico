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
    if @company.save
      redirect_to companies_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @company = Company.find(params[:id])
    @client = Client.new
    @clients = Client.where(company_id: @company.id)
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
