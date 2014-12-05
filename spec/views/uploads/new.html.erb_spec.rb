require 'rails_helper'

RSpec.describe "uploads/new", :type => :view do
  before(:each) do
    assign(:upload, Upload.new())
  end

  it "renders new upload form" do
    render

    assert_select "form[action=?][method=?]", uploads_path, "post" do
    end
  end
end
