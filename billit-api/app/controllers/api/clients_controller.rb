class Api::ClientsController < ApplicationController
before_action :authenticate_user!
before_action :set_client, only: [:show, :update, :destroy]
before_action :require_admin, only: [:create, :update, :destroy]

  def index
    render json: current_user.clients, each_serializer: ClientSerializer
  end

  def show
    render json: @client, serializer: ClientSerializer
  end

  def create
    client = current_user.clients.build(client_params)
    if client.save
      render json: client, serializer: ClientSerializer, status: :created
    else
      render json: { errors: client.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @client.update(client_params)
      render json: @client, serializer: ClientSerializer
    else
      render json: { errors: @client.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @client.destroy
    head :no_content
  end

  private

  def require_admin
    unless current_user.admin?
      render json: { error: "Forbidden" }, status: :forbidden
    end
  end

  def set_client
    @client = current_user.clients.find(params[:id])
  end

  def client_params
    params.require(:client).permit(:name, :company, :email, :address)
  end
end
