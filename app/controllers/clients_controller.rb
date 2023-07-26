class ClientsController < ApplicationController
  before_action :set_clients, only: %i[ show edit update destroy ]
  before_action :client_params, only: %i[ create ]
  before_action :set_company_user, only: %i[ show index edit new create]

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
  end

  private

  def client_params
    params.require(:client).permit(:name, :address, :phone)
  end

  def set_clients
    @client = Client.find(params[:id])
  end

  def set_company_user
    @company = Company.find(params[:company_id])
  end
end
