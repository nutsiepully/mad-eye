
require 'watir-webdriver'
require 'headless'

#headless = Headless.new
#headless.start
browser = Watir::Browser.new

browser.goto "http://www.flysaa.com/in/en/home!loadHome.action?request_locale=en_IN&splashLocale=EN&splashCntry=IN&isCookieEnabled=false"

browser.execute_script '$(\'input[placeholder="Departure City"]\')[0].value = "Luanda, Angola"'
browser.execute_script '$(\'input[placeholder="Destination City"]\')[0].value = "Dubai, United Arab Emirates"'

browser.execute_script '$(\'select#departCity\')[0].value = "LAD"'
browser.execute_script '$(\'select#destCity\')[0].value = "DXB"'

puts browser.execute_script 'return $(\'select#departCity\')[0].value'
puts browser.execute_script 'return $(\'select#destCity\')[0].value'

browser.execute_script '$(\'input#departDay\')[0].value = "25"'
browser.execute_script '$(\'input#departMonthYear\')[0].value = "Jul-2012"'
browser.execute_script '$(\'input#dateDepart\')[0].value = "25-Jul 12"'

puts browser.execute_script 'return $(\'select#departCity\')[0].value'
puts browser.execute_script 'return $(\'select#destCity\')[0].value'

browser.execute_script '$(\'input#destDay\')[0].value = "30"'
browser.execute_script '$(\'input#returnMonthYear\')[0].value = "Jul-2012"'
browser.execute_script '$(\'input#dateDest\')[0].value = "30-Jul 12"'

puts browser.execute_script 'return $(\'select#departCity\')[0].value'
puts browser.execute_script 'return $(\'select#destCity\')[0].value'

browser.a(:text => 'Book').click

browser.close
#headless.destroy
