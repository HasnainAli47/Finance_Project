class DropBalanceAtBillTimeTable < ActiveRecord::Migration[7.0]
  
    def up
      drop_table :balance_at_bill_times
    end
  
  
end
