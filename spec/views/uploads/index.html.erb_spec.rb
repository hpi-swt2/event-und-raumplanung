require 'rails_helper'

RSpec.describe "uploads/index", :type => :view do
  before(:each) do
    assign(:uploads, [
      Upload.create!(),
      Upload.create!()
    ])
  end

  it "renders a list of uploads" do
    render
  end
end
