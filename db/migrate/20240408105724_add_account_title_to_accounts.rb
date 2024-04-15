class AddAccountTitleToAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :account_title, :string
  end
end
