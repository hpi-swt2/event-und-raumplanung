require 'rails_helper'

RSpec.describe "event_suggestions/edit", :type => :view do
  before(:each) do
    @event_suggestion = assign(:event_suggestion, FactoryGirl.create(:event_suggestion))
  end

  # it "renders the edit event_suggestion form" do
  #   render

  #   assert_select "form[action=?][method=?]", event_suggestion_path(@event_suggestion), "post" do

  #     assert_select "input#event_suggestion_starts_at[name=?]", "event_suggestion[starts_at]"

  #     assert_select "input#event_suggestion_ends_at[name=?]", "event_suggestion[ends_at]"

  #     assert_select "input#event_suggestion_status[name=?]", "event_suggestion[status]"

  #     assert_select "input#event_suggestion_room_id[name=?]", "event_suggestion[room_id]"
  #   end
  # end
end
