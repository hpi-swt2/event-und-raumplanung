class Task < ActiveRecord::Base
  belongs_to :event
  has_many :attachments
end
