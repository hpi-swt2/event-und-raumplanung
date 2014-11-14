class Task < ActiveRecord::Base
  belongs_to :event, :user
end
