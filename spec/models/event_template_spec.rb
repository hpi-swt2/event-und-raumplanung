require_relative '../../app/models/event'
require 'spec_helper'


describe "event_template order" do
    before(:all) do
      EventTemplate.destroy_all
      @event1 = FactoryGirl.create(:sortEventT1)
      @event2 = FactoryGirl.create(:sortEventT2)    
      @event3 = FactoryGirl.create(:sortEventT3)  
    end

    it "should have options_for_sorted_by" do
      EventTemplate::options_for_sorted_by
    end

    it "should sort by created at" do
      @events = EventTemplate.sorted_by("created_at_desc")
    end

    it "should sort by name" do
      @events = EventTemplate.sorted_by("name_desc")
      @order = @events.map { |event| event.name[1,1] } 
      expect(@order).to eq ['2','3','1']
    end
     
    it "unexpected should raise error " do
      expect { EventTemplate.sorted_by("narf_desc") }.to raise_error     
    end
     it "should find A1" do
      @events = EventTemplate.search_query("A1");
      expect(@events.size).to be >= 1
      expect(@events).to include @event1
    end
  end
