require 'rails_helper'

RSpec.describe "groups/show", :type => :view do
  let(:user) { create :user }
  
  before(:each) do
  	@request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user

    @group = assign(:group, Group.create!(
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
  end
end
