class AddAccountsReferenceToBill < ActiveRecord::Migration[7.0]
  def change
    add_reference :bills, :account, foreign_key: true
  end
end
