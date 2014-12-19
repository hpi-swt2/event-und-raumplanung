require 'rails_helper'

RSpec.describe "layouts/application", :type => :view do
  let(:hpi_user) { create :hpiUser }
  let(:admin_user) { create :adminUser }

  def sign_in_test_user(user)
    @request.env["devise.mapping"] = Devise.mappings[user]
    sign_in user
    @current_user = user
  end

  it "doesn't show the room requests link to normal users" do    
    sign_in_test_user hpi_user
    render

    assert_select ".navbar-default" do 
      assert_select "a[href=?]", events_approval_path, false
    end
  end

  it "shows the room requests link to admin users" do    
    sign_in_test_user admin_user
    render

    assert_select ".navbar-default" do 
      assert_select "a[href=?]", events_approval_path
    end
  end

  it "shows the navigation links" do    
    sign_in_test_user hpi_user
    render

    assert_select ".navbar-default" do
      assert_select "a[href=?]", root_path
      assert_select "a[href=?]", events_path
      assert_select "a[href=?]", rooms_path
      assert_select "a[href=?]", equipment_index_path
      assert_select "a[href=?]", groups_path
    end
  end
end
