class DropBalanceAtBillTimeTablesTable < ActiveRecord::Migration[7.0]
  def up
    drop_table :balance_at_bill_time_tables
  end
end
