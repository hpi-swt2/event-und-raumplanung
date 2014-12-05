require 'rails_helper'

RSpec.describe "uploads/edit", :type => :view do
  before(:each) do
    @upload = assign(:upload, Upload.create!())
  end

  it "renders the edit upload form" do
    render

    assert_select "form[action=?][method=?]", upload_path(@upload), "post" do
    end
  end
end
