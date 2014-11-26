require 'rails_helper'

RSpec.describe "groups/edit", :type => :view do
  
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  before(:each) do
    @group = Group.build valid_attributes
  end

  it "renders the edit group form" do
    render

    assert_select "form[action=?][method=?]", group_path(@group), "post" do

      assert_select "input#group_name[name=?]", "group[name]"
    end
  end
end
