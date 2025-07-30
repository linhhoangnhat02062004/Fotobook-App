class AddAdminAndStatusToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :admin, :boolean
    add_column :users, :status, :string
  end
end
