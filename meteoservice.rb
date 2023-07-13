require 'net/http'
require 'uri'
require 'rexml/document'

CLOUDINESS = {0 => 'Ясно', 1 => 'Малооблачно', 2 => 'Облачно', 3 => 'Пасмурно'}

uri = URI.parse('https://xml.meteoservice.ru/export/gismeteo/point/434.xml')
response = Net::HTTP.get_response(uri)
doc = REXML::Document.new(response.body)

city_name = URI.decode_uri_component(doc.root.elements['REPORT/TOWN'].attributes['sname'])

current_forecast = doc.root.elements['REPORT/TOWN'].elements.to_a[0]

min_temp = current_forecast.elements['TEMPERATURE'].attributes['min']
max_temp = current_forecast.elements['TEMPERATURE'].attributes['max']

max_wind = current_forecast.elements['WIND'].attributes['max']

cloud_index = current_forecast.elements['PHENOMENA'].attributes['cloudiness'].to_i
clouds = CLOUDINESS[cloud_index]

puts city_name
puts "Temperature: from #{min_temp} to #{max_temp}"
puts "Wind up to #{max_wind} m/s"
puts clouds