class CompaniesController < ApplicationController

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
      render :new
    end
  end

  private

  def company_params
    params.require(:company).permit(:name_company)
  end
end
