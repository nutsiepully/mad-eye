
require 'watir-webdriver'
require 'headless'

headless = Headless.new
headless.start
browser = Watir::Browser.new

browser.goto "http://www.kenya-airways.com/default_en.aspx"

browser.radio(:id => 'ctl00_cph_flightsearch_pagekqbookingengine_rblBooking_0').set
#browser.radio(:id => 'ctl00_cph_flightsearch_pagekqbookingengine_rblBooking_1').set

browser.select(:id => 'ctl00_cph_flightsearch_pagekqbookingengine_lstFrom').select_value('LAD')
browser.select(:id => 'ctl00_cph_flightsearch_pagekqbookingengine_lstTo').select_value('DXB')

browser.text_field(:id => 'ctl00_cph_flightsearch_pagekqbookingengine_txtDepartureDate').set('03-08-2012')
browser.text_field(:id => 'ctl00_cph_flightsearch_pagekqbookingengine_txtReturnDate').set('07-08-2012')

browser.select(:id => 'ctl00_cph_flightsearch_pagekqbookingengine_lstCabinClass').select_value('B')

browser.button(:id => 'ctl00_cph_flightsearch_pagekqbookingengine_cmdGo').click

browser.frame().wait_until_present(120)
puts browser.frame().td(:id => 'cell_3_3').text

browser.close
headless.destroy

