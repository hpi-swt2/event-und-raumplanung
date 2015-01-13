class UsersController < ApplicationController
	before_action :authenticate_user!

	respond_to :json

	def autocomplete
		if params[:search]
			users = User.where("username LIKE ?", "%#{params[:search]}%")
			json_users = users.collect{ |u| {label: u.username, value: u.username, id: u.id} }
			respond_with json_users
		end
	end
end