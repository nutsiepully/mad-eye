
require 'rexml/document'
require 'csv'
require 'nokogiri'
require 'fileutils'

$LOAD_PATH.unshift File.dirname(__FILE__)
require 'record.rb'
require 'price.rb'
require 'sinair_finder.rb'
require 'emirates_finder.rb'
require 'cathay_finder.rb'
require 'malaysia_finder.rb'
require 'thai_finder.rb'

include REXML

STDOUT.sync = true

$airline = ARGV[1] || "sin"
csv_input_file = ARGV[0] || "20120112_Analysis of fares_17h00.csv"
a = csv_input_file
csv_output_file = a[0..a.length - 5] + "_#{$airline}_result" + a[a.length - 4..a.length - 1]

class Time
	def month_year_string
		(self.month < 10 ? "0" : "") + self.month.to_s + self.year.to_s
	end
end

def reset_price_state
	$find_price_state = {
		:call_failed => 0,
		:different_dates => 0
	}
end

def get_airline_finder airline
	case airline
		when "sin"
			return SinairFinder.new
		when "em"
			return EmiratesFinder.new
		when "cp"
			return CathayFinder.new
		when "mal"
			return MalaysiaFinder.new
		when "thai"
			return ThaiFinder.new
		else
			raise StandardError.new
	end
end

def get_date_string_for_record date_obj
	months = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
	date_obj.day.to_s + "-" + months[date_obj.month - 1] + "-" + date_obj.year.to_s[-2..-1]
end

def url_encode x
	return "" if x.nil?
	ret = URI.escape(x, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
	ret = ret.gsub("%20", "+")
end

Dir.mkdir "#{$airline}_calls" if not Dir.exists? "#{$airline}_calls"

$finder = get_airline_finder $airline

def find_price_for_record record, i, should_continue = false
	puts; puts "Finding price for #{record}, #{record.travel_class} at counter #{i}"
	$finder.get_result_for_record record, i

	price = $finder.fetch_price_result($finder.get_result_file_name(record, i))
	puts "Price fetched is #{price}"

	if price.is_a? Symbol
		if price != :call_failed
			$find_price_state[:call_failed] = 0
		end
		case price
			when :call_failed
				$find_price_state[:call_failed] += 1
				if $find_price_state[:call_failed] > 2
					return "call_failure"
				end
				$finder.refresh_session i
				return find_price_for_record record, i, should_continue
			when :different_dates
				return "different dates" if not should_continue
				$find_price_state[:different_dates] += 1
				return "No Flights available within 5 days" if $find_price_state[:different_dates] > 5
				record.departure_date += 1; record.return_date += 1
				price = find_price_for_record record, i, should_continue
			when :route_not_supported
				return "not served"
			when :not_available
				return "not_available"
			when :error
				return "error"
			else
				return "not_found"
		end
	end
	price
end

def write_row csv, row
	csv << row
	csv.flush
end

def set_price_result record, travel_class, price_result
	if price_result.is_a? String
		record.prices[travel_class] = price_result
	else
		record.prices[travel_class] = price_result[0]
		record.stop_count[travel_class] = [price_result[1], price_result[2]]
	end
end

puts "Reading input records"

records = []; csv_records = []
csv_records = CSV.read(csv_input_file)

csv_existing_records = []
if File.exists? csv_output_file
	puts "Reading existing records"
	FileUtils.copy csv_output_file, csv_output_file + ".bak"
	csv_existing_records = CSV.read(csv_output_file)
end

mode = csv_existing_records.count < 5 ? "wb" : "ab"
csv = CSV.open(csv_output_file, mode)

csv_records.each_with_index do |row, i|
	if i < 2
		write_row(csv, row) if mode == "wb"
		next
	end

	records << Record.new(row)
end

puts; puts "Let the crawling begin"

i = (mode == "wb") ? 0 : csv_existing_records.count - 2
while i < records.count
	record = records[i]
	row = csv_records[i + 2]
	puts "*" * 100
	puts; puts "Running script for record - #{record}, counter - #{i}"

	if not record.valid?
		puts; puts "Invalid record at counter #{i}"
		row[8] = "INVALID RECORD"
		row[9] = record.error_message
		write_row csv, row
		i += 1
		next
	end

	$finder.refresh_session i if i % 5 == 0

	date_changed = false
	["economy", "business"].each do |travel_class|
		record.travel_class = $finder.map_travel_class travel_class
		reset_price_state
		set_price_result record, travel_class, find_price_for_record(record, i)
	end
	if record.prices["economy"] == "different dates" and \
		record.prices["business"] == "different dates"
		date_changed = true
		record.travel_class = $finder.map_travel_class "business"
		reset_price_state
		set_price_result record, "business", find_price_for_record(record, i, true)
	end
	record.travel_class = nil

	puts "Record at #{i} is #{record}"

	["business", "economy"].each_with_index do |travel_class, ind|
		if record.prices[travel_class].is_a? String
			row[8 + 7 * ind] = record.prices[travel_class]
		else
			record.prices[travel_class].sort! { |a,b| a.price <=> b.price }
			[3, record.prices[travel_class].count].min.times do |j|
				row[8 + 7 * ind + j * 2] = record.prices[travel_class][j].category
				row[8 + 7 * ind + j * 2 + 1] = record.prices[travel_class][j].price

				if ind == 1 then row[14] = record.prices[travel_class][0].price; end
			end
		end
	end
	if date_changed and record.prices["business"] != "No Flights available within 5 days"
		row[4] = get_date_string_for_record record.departure_date
		row[5] = get_date_string_for_record record.return_date
	end
	row[21] = record.stop_count_string

	puts "Row is being inserted. #{row}"
	puts; puts "*" * 100
	write_row csv, row

	i += 1
end













