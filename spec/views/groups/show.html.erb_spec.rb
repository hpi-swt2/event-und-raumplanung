require 'rails_helper'

RSpec.describe "groups/show", :type => :view do
  let(:user) { create :user }
  
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  before(:each) do
  	@request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user

    group = Group.build valid_attributes
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
  end
end
