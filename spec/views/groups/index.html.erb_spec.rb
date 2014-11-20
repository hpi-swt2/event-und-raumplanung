require 'rails_helper'

RSpec.describe "groups/index", :type => :view do
  let(:user) { create :user }

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
    
    assign(:groups, [
      Group.create!(
        :name => "Name"
      ),
      Group.create!(
        :name => "Test"
      )
    ])
  end

  it "renders a list of groups" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 1
    assert_select "tr>td", :text => "Test".to_s, :count => 1
  end
end
