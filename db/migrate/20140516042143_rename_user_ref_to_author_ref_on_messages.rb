class RenameUserRefToAuthorRefOnMessages < ActiveRecord::Migration
  def change
    remove_reference :messages, :user
    add_reference :messages, :author, index: true
  end
end
