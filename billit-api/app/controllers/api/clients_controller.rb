class Api::ClientsController < ApplicationController
  before_action :set_client, only: [:show, :update, :destroy]

  def index
    render json: current_user.clients
  end

  def show
    render json: @client
  end

  def create
    client = current_user.clients.build(client_params)
    if client.save
      render json: client, status: :created
    else
      render json: { errors: client.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @client.update(client_params)
      render json: @client
    else
      render json: { errors: @client.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @client.destroy
    head :no_content
  end

  private

  def set_client
    @client = current_user.clients.find(params[:id])
  end

  def client_params
    params.require(:client).permit(:name, :company, :email, :address)
  end
end
