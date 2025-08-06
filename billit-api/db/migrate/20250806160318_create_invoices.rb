class CreateInvoices < ActiveRecord::Migration[8.0]
  def change
    create_table :invoices do |t|
      t.references :user, null: false, foreign_key: true
      t.references :client, null: false, foreign_key: true
      t.date :issue_date
      t.date :due_date
      t.integer :status
      t.decimal :tax
      t.decimal :discount
      t.decimal :total
      t.text :note

      t.timestamps
    end
  end
end
