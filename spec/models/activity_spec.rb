require 'rails_helper'

RSpec.describe Activity, :type => :model do

  describe "determinating the glyphicon class" do
  	it "returns the correct css class" do
  		activity = Activity.new :controller => "tasks", :task_info => ["task", "done"]
  		expect(activity.get_css_class).to eq("glyphicon glyphicon-ok")
  		activity = Activity.new :controller => "tasks", :task_info => ["task", nil]
  		expect(activity.get_css_class).to eq("glyphicon glyphicon-remove")
  		activity = Activity.new :controller => "events", :action => "create"
  		expect(activity.get_css_class).to eq("glyphicon glyphicon-plus")
  		activity = Activity.new :controller => "events", :action => "update"
  		expect(activity.get_css_class).to eq("glyphicon glyphicon-cog")
  		activity = Activity.new :controller => "events", :action => "approve"
  		expect(activity.get_css_class).to eq("glyphicon glyphicon-ok")
  		activity = Activity.new :controller => "events", :action => "decline"
  		expect(activity.get_css_class).to eq("glyphicon glyphicon-remove")
  	end
	end
end
