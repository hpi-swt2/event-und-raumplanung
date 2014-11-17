class Task < ActiveRecord::Base
  belongs_to :event
  has_many :attachments, inverse_of: :task
  accepts_nested_attributes_for :attachments
end
