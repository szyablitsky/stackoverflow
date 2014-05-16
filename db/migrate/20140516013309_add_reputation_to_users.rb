class AddReputationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :reputation, :integer, default: 1
  end
end
