class Upload < ActiveRecord::Base
  belongs_to :task

  has_attached_file :file,
                    :path => ":rails_root/public/files/:id/:filename",
                    :url  => "/files/:id/:filename"

  validates_attachment :file,
                       :content_type => { :content_type => ["image/jpeg", "image/gif", "image/png", "application/pdf", "application/msword", "application/vnd.openxmlformats-officedocument.presentationml.presentation", "text/plain", "application/vnd.ms-excel"] }

  validates_with AttachmentSizeValidator, :attributes => :file, :less_than => 1.megabytes

end
