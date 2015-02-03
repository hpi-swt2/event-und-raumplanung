require 'rails_helper'

describe TasksHelper, :type => :helper do
	it 'return correct public URL' do
		url = public_url(1, "test.pdf")
		expect(url).to eq '/files/1/test.pdf'
	end
end