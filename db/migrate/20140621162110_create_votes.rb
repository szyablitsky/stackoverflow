class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.boolean :up
      t.references :message, index: true
      t.references :user, index: true

      t.timestamps
    end

    add_index :votes, [:message_id, :user_id], unique: true
  end
end
