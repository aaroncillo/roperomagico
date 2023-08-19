class PagosController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy ]
  def index
    @filtered = Pago.all.where(company_id: params[:company_id]).order(fecha_gasto: :asc)
    @pagy, @pagos = pagy(@filtered.all, items: 6)
  end

  def new
    @editing = false
    @company = Company.find(params[:company_id])
    @pago = Pago.new
  end

  def create
    @company = Company.find(params[:company_id])
    @pago = Pago.new(pago_params)
    @pago.company = @company
    if @pago.save
      redirect_to company_pagos_path(@company), notice: 'Pago was successfully created.', status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @company = Company.find(params[:company_id])
    @pago = Pago.new
    filtered = Pago.where(company_id: @company.id).order(init_date: :asc)
    @pagy, @pagos = pagy(filtered.all, items: 6)
  end

  def edit
    @editing = true
    @pago = Pago.find(params[:id])
  end

  def update
    if @pago.update(pago_params)
      redirect_to company_pagos_path(@pago.company), notice: 'Pago was successfully updated.'
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    @pago.destroy
    redirect_to company_pagos_path(@pago.company), notice: 'Pago was successfully destroyed.', status: :see_other
  end

  private

  def set_product
    @pago = Pago.find(params[:id])
  end

  def pago_params
    params.require(:pago).permit(:name_gasto, :description_gasto, :precio_gasto, :fecha_gasto)
  end
end
