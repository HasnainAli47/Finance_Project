class CreateBalanceAtBillTimeTable < ActiveRecord::Migration[7.0]
  def change
    create_table :balance_at_bill_time_tables do |t|
      
      t.timestamps
    end
  end
end
