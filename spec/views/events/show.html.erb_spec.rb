require 'rails_helper'
require 'pp'

RSpec.describe "events/show", :type => :view do

  let(:user) { create :user }

  before(:each) do

    @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in user

    @event = assign(:event, Event.create!(name:"Testeventname", description: "description of the testevent", participant_count:87,
                                          created_at: DateTime.new(2000,02,25,4,5,6), updated_at: DateTime.new(2001,03,20,5,6,7),
                                          starts_at: DateTime.new(2050, 05, 03, 15, 00),
                                          ends_at:  DateTime.new(2050,05, 04, 16,45),
                                          rooms: [build(:room)],
                                          user_id: user.id+1, is_private: true))

    @event.activities << Activity.create(:username => "user", 
                                          :action => "action", :controller => "controller",
                                          :changed_fields => @event.changed)
    
    @activities = @event.activities
    @feed_entries = @activities
    @current_user = user

    @favorite = Favorite.where('user_id = ? AND favorites.is_favorite = ? AND event_id = ?', user.id, true, @event.id);

    @tasks = []
  end

  it "renders attributes in <p>" do
    render
  end

  it "displays the event details" do
    #render
    #expect(rendered).to include(@event.name)
    #expect(rendered).to include(@event.description)
    #expect(rendered).to include(@event.participant_count.to_s)
    #expect(rendered).to include(@event.created_at.strftime("%d.%m.%Y %T"))
    #expect(rendered).to include(@event.updated_at.strftime("%d.%m.%Y %T"))
    #expect(rendered).to include(@event.starts_at.strftime("%d.%m.%Y"))
    #expect(rendered).to include(@event.ends_at.strftime("%d.%m.%Y"))
    #expect(rendered).to include("<input checked=\"checked\" disabled=\"disabled\" id=\"private\" name=\"private\" type=\"checkbox\" value=\"private\" />")
    #expect(rendered).to include("<input checked=\"checked\" disabled=\"disabled\" id=\"private\" name=\"private\" type=\"checkbox\" value=\"private\" />")
  end

  it "does display the favorite button for every user that is not event owner" do
    render
    expect(rendered).to include('glyphicon-star')
  end

  it "doesn't display the favorite button for event owner" do
    @event.user_id = user.id
    render
    expect(rendered).to_not include('glyphicon-star')
  end
end
