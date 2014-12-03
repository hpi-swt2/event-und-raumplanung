FactoryGirl.define do
	factory :beamer, class: Equipment do
		name 'Beamer 1'
		description 'A 4:3 Beamer'
	end
	
	factory :wlan, class: Equipment do
		name 'hpi'
		description 'The Campus Wlan accessible by HPI Credentials'
	end
end