require 'test_helper'

class AttachmentTest < ActiveSupport::TestCase
  test "should reject invalid url" do
    attachment = attachments(:one)
    attachment.url = "thisisnotavalidurl";
    assert_not attachment.valid?
  end
end
