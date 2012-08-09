
require 'watir-webdriver'
require 'headless'

headless = Headless.new
headless.start
browser = Watir::Browser.new

browser.goto "http://www.kenya-airways.com/default_en.aspx"

one_way = true

if !one_way
	browser.radio(:id => 'ctl00_cph_flightsearch_pagekqbookingengine_rblBooking_0').set
else
	browser.radio(:id => 'ctl00_cph_flightsearch_pagekqbookingengine_rblBooking_1').set
	sleep(30)
end

browser.select(:id => 'ctl00_cph_flightsearch_pagekqbookingengine_lstFrom').select_value('LAD')
browser.select(:id => 'ctl00_cph_flightsearch_pagekqbookingengine_lstTo').select_value('DXB')

browser.text_field(:id => 'ctl00_cph_flightsearch_pagekqbookingengine_txtDepartureDate').set('04-09-2012')
if (!one_way) 
	browser.text_field(:id => 'ctl00_cph_flightsearch_pagekqbookingengine_txtReturnDate').set('11-09-2012')
end

browser.select(:id => 'ctl00_cph_flightsearch_pagekqbookingengine_lstCabinClass').select_value('E')

browser.button(:id => 'ctl00_cph_flightsearch_pagekqbookingengine_cmdGo').click

browser.frame.wait_until_present

if !one_way
	puts browser.frame.td(:id => 'cell_3_3').text
else
	puts browser.frame.td(:id => 'cell_3_0').text
end

browser.close
headless.destroy

