class CreateJwtDenylists < ActiveRecord::Migration[8.0]
  def change
    create_table :jwt_denylists do |t|
      t.string :jti, index: true, null: false
      t.datetime :exp, null: false

      t.timestamps
    end
  end
end
