class InversionsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy ]

  def index
    @filtered = Inversion.all.where(company_id: params[:company_id]).order(fecha_inversion: :asc)
    @pagy, @inversions = pagy(@filtered.all, items: 6)
  end

  def new
    @editing = false
    @company = Company.find(params[:company_id])
    @inversions = Inversion.new
  end

  def create
    @company = Company.find(params[:company_id])
    @inversion = Inversion.new(inversion_params)
    @inversion.company = @company
    if @inversion.save
      redirect_to company_inversions_path(@company), notice: 'Inversion was successfully created.', status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @company = Company.find(params[:company_id])
    @inversion = Inversion.new
    filtered = Inversion.where(company_id: @company.id).order(init_date: :asc)
    @pagy, @inversions = pagy(filtered.all, items: 6)
  end

  def edit
    @editing = true
    @inversion = Inversion.find(params[:id])
  end

  def update
    if @inversion.update(inversion_params)
      redirect_to company_inversions_path(@inversion.company), notice: 'Inversion was successfully updated.'
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    @inversion.destroy
    redirect_to company_inversions_path(@inversion.company), notice: 'Inversion was successfully destroyed.', status: :see_other
  end

  private

  def set_product
    @inversion = Inversion.find(params[:id])
  end

  def inversion_params
    params.require(:inversion).permit(:name_inversion, :description_inversion, :precio_inversion, :fecha_inversion)
  end
end
