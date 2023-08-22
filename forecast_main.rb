require 'net/http'
require 'rexml/document'
require 'json'

require_relative 'forecast'

file = File.read('towns.json', encoding: "utf-8")
towns = JSON.parse(file)

puts 'Погоду для какого города Вы хотите узнать?
1: Москва
2: Пермь
3: Санкт-Петербург
4: Новосибирск
5: Орел
6: Чита
7: Братск
8: Краснодар
9: Симферополь'

choice = STDIN.gets.to_i

URL = "https://www.meteoservice.ru/export/gismeteo/point/#{towns["#{choice}"]}.xml".freeze

response = Net::HTTP.get_response(URI.parse(URL))
doc = REXML::Document.new(response.body)

city_name = URI.decode_uri_component(doc.root.elements['REPORT/TOWN'].attributes['sname'])
forecast_nodes = doc.root.elements['REPORT/TOWN'].elements.to_a

puts city_name
puts

forecast_nodes.each do |node|
  puts Forecast.from_xml(node)
  puts
end