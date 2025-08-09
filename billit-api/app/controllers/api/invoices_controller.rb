class Api::InvoicesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin, only: [:create, :update, :destroy]

  def index
    render json: current_user.invoices, each_serializer: InvoiceSerializer
  end

  def show
    invoice = current_user.invoices.find(params[:id])
    render json: invoice, serializer: InvoiceSerializer
  end

  def create
    invoice = current_user.invoices.build(invoice_params)
    if invoice.save
      render json: invoice, serializer: InvoiceSerializer, status: 201
    else
      render json: { error: invoice.errors.full_messages.join(', ') }, status: 422
    end
  end

  def update
    if @invoice.update(invoice_params)
      render json: @invoice, serializer: InvoiceSerializer, status: 200
    else
      render json: { error: @invoice.errors.full_messages.join(', ') }, status: 422
    end
  end

  def destroy
    @invoice.destroy
    head 204
  end

  private

  def require_admin
    unless current_user.admin?
      render json: { error: "Forbidden" }, status: :forbidden
    end
  end

  def invoice_params
    params.require(:invoice).permit(
      :issue_date,
      :due_date,
      :status,
      :tax,
      :discount,
      :total,
      :note,
      :client_id,
      line_items_attributes: [
        :id, :description, :quantity, :unit_price, :_destroy
      ]
    )
  end
end
