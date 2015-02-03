require 'rails_helper'

RSpec.describe "events/_rooms.html.erb" do
      
#  before(:each) do
#  end
  
  it "shows equipment" do
    FactoryGirl.create(:equipment, :name => 'c1', :category => 'Chair', :room_id => nil)
    render
    expect(rendered).to include('Chair')
  end
  
end
