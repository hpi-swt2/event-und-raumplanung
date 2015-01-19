require 'rails_helper'

RSpec.describe "groups/edit", :type => :view do
  let(:adminUser) { create :adminUser }
  
  let(:valid_attributes) {
    {
      name: 'groupName',
    }
  }

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:admin]
    sign_in adminUser

    @group = Group.create! valid_attributes
    @users = User.all
  end

  # it "renders the edit group form" do
  #   render

  #   assert_select "form[action=?][method=?]", group_path(@group), "post" do

  #     assert_select "input#group_name[name=?]", "group[name]"
  #   end
  # end
end
