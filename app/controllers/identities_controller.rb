class IdentitiesController < ApplicationController
	before_action :authenticate_user!

	respond_to :json

	def autocomplete
		if params[:search]
			groups = Group.where("LOWER(name) LIKE ?", "%#{params[:search].downcase}%")
			users = User.where("LOWER(username) LIKE ?", "%#{params[:search].downcase}%")
			json_groups = groups.collect{ |g| {label: g.name + " (#{t('groups.group')})", value: g.name + " (#{t('groups.group')})", id: "Group:" + g.id.to_s} } 
			json_users = users.collect{ |u| {label: u.username, value: u.username, id: "User:" + u.id.to_s} }
			respond_with json_groups + json_users
		end
	end
end