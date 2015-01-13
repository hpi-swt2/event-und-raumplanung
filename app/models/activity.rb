class Activity < ActiveRecord::Base
	belongs_to :event
	serialize :changed_fields
	serialize :task_info

	def get_css_class
      css_class = "glyphicon glyphicon-"

      if controller == "tasks"
        if task_info[1]
          css_class += "ok"
        else
          css_class += "remove"
        end
      elsif(controller == "events")
        case action
        when "update"
          css_class += "cog"
        when "create"
          css_class += "plus"
        when "approve"
          css_class += "ok"
        when "decline"
          css_class += "remove"
        end
      end
    end
end
