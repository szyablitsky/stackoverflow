class AddAttachmentsCountToMessages < ActiveRecord::Migration
  def up
    add_column :messages, :attachments_count, :integer, default: 0, null: false

    Message.find_each do |m|
      Message.reset_counters(m.id, :attachments)
    end
  end

  def down
    remove_column :messages, :attachments_count
  end
end
