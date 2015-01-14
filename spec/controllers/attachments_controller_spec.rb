require 'rails_helper'

RSpec.describe AttachmentsController, :type => :controller do
  include Devise::TestHelpers

  let(:valid_session) {
  }
  let(:task) { create :task }
  let(:user) { create :user }


 let(:valid_attributes) {
    {
    	title: "Example",
    	url: "http://example.com",
    	task_id: task.id
    }
  }

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
  end

  describe "GET index" do
    it "assigns all attachments of a task as @attachments" do
      attachment = Attachment.create! valid_attributes
      xhr :get, :index, { :task_id => task.id }, valid_session
      expect(assigns(:attachments)).to eq([attachment])
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Attachment" do
        expect {
          xhr :post, :create, {:attachment => valid_attributes}, valid_session
        }.to change(Attachment, :count).by(1)
      end

      it "assigns a newly created attachment as @attachment" do
        xhr :post, :create, {:attachment => valid_attributes}, valid_session
        expect(assigns(:attachment)).to be_an(Attachment)
        expect(assigns(:attachment)).to be_persisted
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested attachment" do
      attachment = Attachment.create! valid_attributes
      expect {
        xhr :delete, :destroy, {:id => attachment.to_param}, valid_session
      }.to change(Attachment, :count).by(-1)
    end
  end
end