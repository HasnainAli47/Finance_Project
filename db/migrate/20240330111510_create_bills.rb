class CreateBills < ActiveRecord::Migration[7.0]
  def change
    create_table :bills do |t|
      t.decimal :amount
      t.text :description
      t.string :status
      t.string :bill_reference

      t.timestamps
    end
  end
end
