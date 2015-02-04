class EquipmentRequest < ActiveRecord::Base
	belongs_to :room
	belongs_to :event
end
