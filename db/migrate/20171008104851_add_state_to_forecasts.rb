class AddStateToForecasts < ActiveRecord::Migration[5.1]
  def change
    add_column :forecasts, :state, :string
  end
end
