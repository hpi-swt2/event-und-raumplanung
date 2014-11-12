module EventTemplatesHelper


	def viewDate(date, time)
		output = ""
		if date
			output += date.strftime("%d.%m.%Y")
		end
		if date and time
			output += " - "
		end
		if time
			output += time.strftime("%H:%M")
		end
		return output
	end

	def viewDescription(description)
		if description.length > 60
			return description[0, 55] + "[...]"
		end
		return description
	end
end
