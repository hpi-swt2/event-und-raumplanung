require 'rails_helper'
require "cancan/matchers"

RSpec.describe EventTemplatesController, :type => :controller do
  include Devise::TestHelpers

  let(:task) { create :task }
  let(:user) { create :user }

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
  end

  let(:valid_attributes) {
    {name:'Michas GB',
    description:'Coole Sache',
    user_id: user.id,
    participant_count: 1
    }
  }

  describe "GET index" do
    it "assigns all event_templates as @event_templates" do
      event_template = FactoryGirl.create(:event_template)
      get :index
      expect(assigns(:event_templates)).to eq([event_template])
    end
  end

  describe "GET show" do
    it "assigns the requested event_template as @event_template" do
      event_template = FactoryGirl.create(:event_template)
      get :show, {:id => event_template.to_param}
      expect(assigns(:event_template)).to eq(event_template)
    end
  end

  describe "GET new" do
    it "assigns a new event_template as @event_template" do
      get :new, {}
      expect(assigns(:event_template)).to be_a_new(EventTemplate)
    end
  end

  describe "GET new_event" do
    it "assigns a new event as @event" do
      event_template = FactoryGirl.create(:event_template)
      get :new_event, {:id => event_template.to_param}
      expect(assigns(:event).name).to eq event_template.name
      expect(assigns(:event).description).to eq event_template.description
      expect(response).to render_template("events/new")
    end
  end

  describe "GET edit" do
    it "assigns the requested event_template as @event_template" do
      event_template = FactoryGirl.create(:event_template)
      get :edit, {:id => event_template.to_param}
      expect(assigns(:event_template)).to eq(event_template)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new EventTemplate" do
        expect {
          post :create, {:event_template => valid_attributes}
          }.to change(EventTemplate, :count).by(1)
      end

      it "assigns a newly created event_template as @event_template" do
        post :create, {:event_template => valid_attributes}
        expect(assigns(:event_template)).to be_a(EventTemplate)
        expect(assigns(:event_template)).to be_persisted
      end

      it "redirects to the created event_template" do
        post :create, {:event_template => valid_attributes}
        expect(response).to redirect_to(EventTemplate.last)
      end

    end
  end
end
