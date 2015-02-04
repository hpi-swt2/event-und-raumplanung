class CommentsController < ApplicationController
  before_action :authenticate_user!

  def show
  end

  def new
    @comment = Comments.new
  end

  def edit
  end

  def update
  end

end
