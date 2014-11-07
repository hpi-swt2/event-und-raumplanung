class Attachment < ActiveRecord::Base
  belongs_to :task

  validates_presence_of :title, :url
end
