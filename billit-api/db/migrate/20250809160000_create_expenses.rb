class CreateExpenses < ActiveRecord::Migration[7.0]
  def change
    create_table :expenses do |t|
      t.references :user, null: false, index: true
      t.string :description, null: false
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.string :category, null: false, index: true
      t.date :expense_date, null: false

      t.timestamps
    end

    add_check_constraint :expenses, 'amount > 0', name: 'amount_positive'
  end
end
