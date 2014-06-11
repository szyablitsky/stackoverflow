class AddAcceptedToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :accepted, :boolean, default: false
  end
end
