class Activity < ActiveRecord::Base
	belongs_to :event
	serialize :changed_fields
end
