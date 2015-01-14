class IdentitiesController < ApplicationController
	before_action :authenticate_user!

	respond_to :json

	def autocomplete
		if params[:search]
			groups = Group.where("LOWER(name) LIKE ?", "%#{params[:search].downcase}%")
			users = User.where("LOWER(username) LIKE ?", "%#{params[:search].downcase}%")
			json_groups = groups.collect{ |g| {label: "Group: " + g.name, value: "Group: " + g.name, id: "Group:" + g.id.to_s} } 
			json_users = users.collect{ |u| {label: "User: " + u.username, value: "User: " + u.username, id: "User:" + u.id.to_s} }
			respond_with json_groups + json_users
		end
	end
end