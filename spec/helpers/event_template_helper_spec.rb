require 'rails_helper'

describe EventTemplatesHelper, :type => :helper do
  describe "function 'trimDescription'" do
    it "trims text longer than 55" do
        @trimstring = trimDescription('Hallo1234'*10)
    	expect(@trimstring.length).to be <= 60   
    	expect(@trimstring).to end_with('[...]')  
    end
    it "doesnt trim text shorter than 55" do
        @trimstring = trimDescription('Hallo1234') 
    	expect(@trimstring).to eql 'Hallo1234'  
    end
  end
  describe "function 'nl2br'" do
    it "replaces new lines though html <br> tags" do
        @string = nl2br("Hallo\nHallo")
    	expect(@string).to eql 'Hallo<br>Hallo'
    end
  end
  describe "function 'concat_rooms'" do
  	let(:room1) {stub_model Room, name:"Test1" }
 	let(:room2) {stub_model Room, name:"Test2" }
 	let(:event) {stub_model Event, rooms:[room1,room2] }
  
    it "concat rooms" do
        @string = concat_rooms(event) 
        expect(@string).to include 'Test1'
        expect(@string).to include 'Test2'
        expect(@string).to include 'nd'
    end
  end
end