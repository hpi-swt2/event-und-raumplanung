require 'rails_helper'

describe EventTemplatesHelper, :type => :helper do
  describe "trimDescription" do
    it "trims longer than 55" do
        @trimstring = trimDescription('Hallo'*10)
    	expect(@trimstring.length).to be < 60       
    end
  end
end