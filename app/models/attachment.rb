class Attachment < ActiveRecord::Base
  belongs_to :message

  mount_uploader :file, AttachmentUploader
end
