class RemoveUserFromBills < ActiveRecord::Migration[7.0]
  def change
    remove_reference :bills, :user, null: false, foreign_key: true
  end
end
