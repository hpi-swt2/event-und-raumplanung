require 'rails_helper'
require 'pry'

RSpec.describe IdentitiesController, type: :controller do

  describe "GET autocomplete" do
  	let(:user) { create :user }
  	let(:mustermann) { create :user, username: "max_mustermann" }
  	let(:group) { create :group, name: "Mustergruppe" }

	before(:each) { sign_in user }

  	it 'answers with group and user' do
  		mustermann
  		group
  		create :group
  		create :user
  		
	    search = "muster";
	    get :autocomplete, search: search, format: :json
	    expect(JSON.parse(response.body)[0]['id']).to eq "Group:#{group.id}"
	    expect(JSON.parse(response.body)[1]['id']).to eq "User:#{mustermann.id}"
	end
  end
end