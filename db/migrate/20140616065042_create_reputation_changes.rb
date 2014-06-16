class CreateReputationChanges < ActiveRecord::Migration
  def change
    create_table :reputation_changes do |t|
      t.integer :amount
      t.integer :type
      t.references :message, index: true
      t.references :receiver, index: true
      t.references :committer, index: true

      t.timestamps
    end
  end
end
