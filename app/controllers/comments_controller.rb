class CommentsController < ApplicationController

  def show
  end

  def new
    @comment = Comments.new
  end

  def edit
  end

  def create
    @comment = Comments.new(comment_params)
    respond_to do |format|
      if @comment.save
        format.html { redirect_to @comment, notice: t('notices.successful_create', :model => Comments.model_name.human) }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
  end

end
