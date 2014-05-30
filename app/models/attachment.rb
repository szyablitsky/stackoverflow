class Attachment < ActiveRecord::Base
  belongs_to :message, counter_cache: true

  mount_uploader :file, AttachmentUploader
end
