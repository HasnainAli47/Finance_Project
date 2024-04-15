class CreateBalanceAtBillTimes < ActiveRecord::Migration[7.0]
  def change
    create_table :balance_at_bill_times do |t|
      t.decimal :current_balance

      t.timestamps
    end
  end
end
