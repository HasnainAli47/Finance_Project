class CreateAccount < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.decimal :CurrentBalance

      t.timestamps
    end
  end
end
