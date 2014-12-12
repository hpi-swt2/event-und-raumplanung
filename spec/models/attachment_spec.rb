require 'spec_helper'

describe Attachment do
  it "should reject invalid urls" do
  	@attachment = FactoryGirl.build(:attachment_with_invalid_url)
  	expect(@attachment.valid?).to be false
  end
end