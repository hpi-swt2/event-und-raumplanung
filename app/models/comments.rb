class Comments < ActiveRecord::Base
  belongs_to :event
  belongs_to :user

  validates_presence_of :user_id, :content, :event_id
  validates_length_of :content, :maximum => 255
end
