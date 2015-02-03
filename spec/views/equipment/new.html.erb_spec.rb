require 'rails_helper'

RSpec.describe "equipment/new", :type => :view do
  let(:user) { create :user }
  
  let(:valid_attributes) {
    {
      name: 'Beamer HD',
      category: 'Beamer'
    }
  }

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:adminUser]
    sign_in user

    @equipment = Equipment.create! valid_attributes
  end

  it "renders the edit equipment form" do

    render

    assert_select "h1", :count => 1
    assert_select "label", :count => 4
    assert_select "a", :count => 1
  end
end
