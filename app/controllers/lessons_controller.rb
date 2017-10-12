class LessonsController < ApplicationController
  def show
    @topic = Topic.friendly.find(params[:topic_id])
    @lesson = @topic.lessons.with_level(params[:id]).take
    redirect_to @topic && return if @lesson.nil?

    respond_to do |format|
      format.html { render "topics/show" }
      format.js
    end
  end
end
