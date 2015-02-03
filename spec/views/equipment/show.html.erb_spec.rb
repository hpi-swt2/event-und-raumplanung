require 'rails_helper'

RSpec.describe "equipment/show", :type => :view do

  before(:all) do
    @default_locale = I18n.default_locale
  end
    

  let(:user) { create :user }

  let(:valid_attributes) {
    {
      name: 'Beamer HD',
      category: 'Beamer'
    }
  }

  before(:each) do
  	@request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user

    @equipment = Equipment.create! valid_attributes
  end

  it "renders attributes" do
    render
    expect(rendered).to match("Beamer")
  end

  it "renders the title" do
    render
    assert_select "h1", :text => "Beamer HD".to_s, :count => 1
  end

  it "renders the data list" do
    render
    assert_select "dl", :count => 1
  end

end
