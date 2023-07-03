require 'net/http'
require 'uri'
require 'nokogiri'
require 'json'
require 'date'
require 'pry'

url = URI('https://www.')
user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0) Gecko/20100101 Firefox/91.0'

http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true if url.scheme == 'https' # Enable SSL/TLS
request = Net::HTTP::Get.new(url.request_uri, 'User-Agent' => user_agent)

while true
  $stdout.puts "Checking at #{Time.now}"

  response = http.request(request)

  doc = Nokogiri.parse(response.body)

  products = doc.at_css('#product-details')['data-product']
  product_details = JSON.parse(products)

  if product_details['availability'] == 'available' || !product_details['availability_date'].nil?
    system('osascript -e \'display notification "Produit En stock" with title "Alerte de disponibilité"\'')
  end

  sleep 300 # sleep for 5 minutes
end
