class InvoiceSerializer < ActiveModel::Serializer
  attributes :id, :issue_date, :due_date, :status, :tax, :discount, :total, :note

  attribute :client do
    object.client.name
  end

  has_many :line_items, serializer: LineItemSerializer

  def total
    object.line_items.sum { |li| li.quantity * li.unit_price }
  end
end
