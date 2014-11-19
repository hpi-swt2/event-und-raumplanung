class Task < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
end
