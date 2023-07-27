class ClientsController < ApplicationController
  before_action :set_client, only: %i[ show edit update destroy ]
  before_action :client_params, only: %i[ create ]
  before_action :set_client_user, only: %i[show index edit new]



  def index
    @clients = Client.all
  end

  def new
    @company = Company.find(params[:company_id])
    @client = Client.new
  end

  def create
    @company = Company.find(params[:company_id])
    @client = Client.new(client_params)
    @client.company = @company
    if @client.save
      redirect_to company_path(@company)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @client = Client.find(params[:id])
    @product = Product.new
    @products = Product.where(client_id: @client.id)

  end

  def edit
  end

  def update
    if @client.update(client_params)
      redirect_to company_path(@client.company), notice: 'Client was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @client.destroy
    redirect_to company_path(@client.company), notice: 'Client was successfully destroyed.', status: :see_other
  end

  private

  def client_params
    params.require(:client).permit(:name, :address, :phone)
  end

  def set_client
    @client = Client.find(params[:id])
  end

  def set_client_user
    @companies = Company.where(user_id: current_user.id)
  end
end