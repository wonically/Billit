class CreateClients < ActiveRecord::Migration[8.0]
  def change
    create_table :clients do |t|
      t.string :name
      t.string :company
      t.string :email
      t.text :address
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
