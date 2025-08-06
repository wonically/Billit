class ClientSerializer < ActiveModel::Serializer
  attributes :id, :name, :company, :email, :address
end
