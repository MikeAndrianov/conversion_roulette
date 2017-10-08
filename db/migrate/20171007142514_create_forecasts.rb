class CreateForecasts < ActiveRecord::Migration[5.1]
  def change
    create_table :forecasts do |t|
      t.string :currency, null: false
      t.float :amount, null: false
      t.string :target_currency, null: false
      t.integer :max_waiting_time, null: false
      t.date :date_from, null: false
      t.date :date_to, null: false
      t.references :forecasts, :user, foreign_key: true

      t.timestamps
    end
  end
end
