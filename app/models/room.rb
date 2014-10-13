class Room < ActiveRecord::Base
  belongs_to :booking
  has_many :equipment # The plural of 'equipment' is 'equipment'
end
