class AddImageToBills < ActiveRecord::Migration[7.0]
  def change
    add_column :bills, :image, :string
  end
end
