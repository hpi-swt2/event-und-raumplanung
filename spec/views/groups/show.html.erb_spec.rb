require 'rails_helper'

RSpec.describe "groups/show", :type => :view do
  let(:user) { create :user }
  
  let(:valid_attributes) {
    {
      name: 'groupName',
    }
  }

  before(:each) do
  	@request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user

    @group = Group.create! valid_attributes
    @users = User.all
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
  end
end
