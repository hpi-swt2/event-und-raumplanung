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
end
