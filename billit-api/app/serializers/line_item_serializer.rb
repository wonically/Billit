class LineItemSerializer < ActiveModel::Serializer
  attributes :id, :description, :quantity, :unit_price, :total_price

  def total_price
    object.total
  end
end
