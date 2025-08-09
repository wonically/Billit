class Api::InvoicesController < ApplicationController
  def index
    invoices = Invoice.all
    render json: invoices, each_serializer: InvoiceSerializer
  end

  def show
    invoice = Invoice.find(params[:id])
    render json: invoice, serializer: InvoiceSerializer
  end

  def create
  end

  def update
  end

  def destroy
  end

  private

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
