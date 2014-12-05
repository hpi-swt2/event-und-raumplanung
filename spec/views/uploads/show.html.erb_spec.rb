require 'rails_helper'

RSpec.describe "uploads/show", :type => :view do
  before(:each) do
    @upload = assign(:upload, Upload.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
