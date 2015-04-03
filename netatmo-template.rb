require 'net/https'
require 'uri'


uri = URI.parse('http://api.netatmo.net/api/getmeasure?')
response = Net::HTTP.post_form(uri, {
  'access_token' => 'ACCESS_TOKEN_HERE',
  'device_id' => 'DEVICE_ID_HERE',
  'scale' => '30min',
  'type' => 'Temperature',
  'limit' => '1'})
print response.body
