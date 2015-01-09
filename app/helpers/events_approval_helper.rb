module EventsApprovalHelper
	def timeslot_as_string(event)
		timeslot_str = '' 
		timeslot_str += event.starts_at.strftime '%H:%M' unless event.starts_at.nil?
		timeslot_str += '-' unless event.starts_at.nil? and event.ends_at.nil?
		timeslot_str += event.ends_at.strftime '%H:%M' unless event.ends_at.nil?
		return timeslot_str
	end

	def timeslot_with_date_as_string(event)
		date_str = ''
		date_str = event.starts_at.strftime '%A, %d/%m/%y ' unless event.starts_at.nil?
		date_str = event.ends_at.strftime '%A, %d/%m/%y ' unless date_str != '' or event.ends_at.nil?
		return date_str + timeslot_as_string(event)
	end
end
