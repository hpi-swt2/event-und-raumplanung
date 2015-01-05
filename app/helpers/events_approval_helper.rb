module EventsApprovalHelper
	def timeslot_as_string(booking)
		timeslot_str = '' 
		timeslot_str += booking.start.strftime '%H:%M' unless booking.start.nil?
		timeslot_str += '-' unless booking.start.nil? and booking.end.nil?
		timeslot_str += booking.end.strftime '%H:%M' unless booking.end.nil?
		return timeslot_str
	end

	def timeslot_with_date_as_string(booking)
		date_str = ''
		date_str = booking.start.strftime '%A, %d/%m/%y ' unless booking.start.nil?
		date_str = booking.end.strftime '%A, %d/%m/%y ' unless date_str != '' or booking.end.nil?
		return date_str + timeslot_as_string(booking)
	end
end
