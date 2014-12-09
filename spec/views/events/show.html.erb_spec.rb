require 'rails_helper'

RSpec.describe "events/show", :type => :view do
  before(:each) do
    @event = assign(:event, Event.create!(name:"Testeventname", description: "description of the testevent", participant_count:87,
                                          created_at: DateTime.new(2000,02,25,4,5,6), updated_at: DateTime.new(2001,03,20,5,6,7),
                                          starts_at: DateTime.new(2050, 05, 03, 15, 00),
                                          ends_at:  DateTime.new(2050,05, 04, 16,45),
                                          user_id: 42, is_private: true))
    @favorite = Favorite.where('user_id = 42 AND favorites.is_favorite=true AND event_id = ?',@event.id);
    #@favorite = assign(:favorite, Favorite.create!(event_id: 1, user_id: 42, is_favorite: true))
  end

  it "renders attributes in <p>" do
    render
  end

  it "displays the event details" do
    render
    expect(rendered).to include(@event.name)
    expect(rendered).to include(@event.description)
    expect(rendered).to include(@event.participant_count.to_s)
    expect(rendered).to include(@event.created_at.strftime("%d.%m.%Y %T"))
    expect(rendered).to include(@event.updated_at.strftime("%d.%m.%Y %T"))
    expect(rendered).to include(@event.starts_at.strftime("%d.%m.%Y"))
    expect(rendered).to include(@event.ends_at.strftime("%d.%m.%Y"))
    expect(rendered).to include("<input checked=\"checked\" disabled=\"disabled\" id=\"private\" name=\"private\" type=\"checkbox\" value=\"private\" />")
    expect(rendered).to include("<input checked=\"checked\" disabled=\"disabled\" id=\"private\" name=\"private\" type=\"checkbox\" value=\"private\" />")
  end

  it "displays the favorite button" do
    render
    expect(rendered).to include("Add Favorite")
  end 

end
