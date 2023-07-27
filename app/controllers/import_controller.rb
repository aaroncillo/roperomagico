class ImportController < ApplicationController
  before_action :set_import, only: [:show, :edit, :update, :destroy]


  def import
    file = params[:file]

    # redirect if  bad data
    return redirect_to root_path, alert: "No file selected" unless file
    return redirect_to root_path, alert: "Please select CSV file instead" unless file.content_type == "text/csv"


    user = current_user
    # import data
    csvImportService = CsvImportService.new(file,user)
    csvImportService.import

    # redirect  witth notice
  end


  def index
    @import = Import.all
  end

  def show
  end

  def edit
  end

  def new
    @import = Import.new
  end

  def create
    @import = Import.new(import_params)
    @import.save
  end

  def update
  end

  def destroy
  end

  private

  def import_params
    params.require(:import).permit(:file)
  end

  def set_import
    @import = Import.find(params[:id])
  end
end
