require 'rails_helper'

RSpec.describe "groups/index", :type => :view do
  let(:user) { create :user }
  let(:adminUser) { create :adminUser }

  before(:each) do
    assign(:groups, [
      Group.create!(
        :name => "Name"
      ),
      Group.create!(
        :name => "Test"
      )
    ])
  end

  before(:each, :isAdmin => false) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
  end

  before(:each, :isAdmin => true) do
    @request.env["devise.mapping"] = Devise.mappings[:adminUser]
    sign_in adminUser
  end

  it "renders a list of groups" do
    skip("partial does not render")
    @groups = [
      Group.create!(
        :name => "Name2"
      ),
      Group.create!(
        :name => "Test2"
      )
    ]
    puts (@groups.inspect)
    view.should render_template(:partial => '_list', locals: { groups: @groups,  model_class:  Group}) 
    assert_select "tr>td", :text => "Name".to_s, :count => 1
    assert_select "tr>td", :text => "Test".to_s, :count => 1
  end

  describe "when signed in as admin" do
    it "render the action column", :isAdmin => true do
      skip("partial does not render")
      render
      assert_select "th", :count => 2
      assert_select "th", :text => t("helpers.actions"), :count => 1
    end
  end

  describe "when signed in as normal user" do
    it "do not render the action column", :isAdmin => false do
      skip("partial does not render")
      render
      assert_select "th", :count => 1
    end
  end
end
