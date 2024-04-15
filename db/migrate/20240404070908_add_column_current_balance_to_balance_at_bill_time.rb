class AddColumnCurrentBalanceToBalanceAtBillTime < ActiveRecord::Migration[7.0]
  def change
    add_column :balance_at_bill_time_tables, :CurrentBalance, :float
  end
end
