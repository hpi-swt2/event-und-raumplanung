require 'rails_helper'

describe EventTemplatesHelper, :type => :helper do
  describe "viewDate" do
    it "formatted date" do
    	d = viewDate Date.new, Time.new
    	expect(d).to match "" 
    	d = viewDate Date.new(2014, 12, 18), Time.new
    	expect(d).to match "18.12.2014"
    	d = viewDate Date.new, Time.new(2012, 8, 29,  1,  0,  0)
    	expect(d).to match "01:00"
    	d = viewDate Date.new(2014, 12, 31), Time.new(2000, 1, 1,  23,  59,  59)
    	expect(d).to match "31.12.2014 - 23:59"

      
    end
  end
end