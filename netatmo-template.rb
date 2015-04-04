require 'net/https'
require 'uri'
require 'yaml'
require 'json'

parsed = begin
  YAML.load(FIle.open("/config/local_env.yml"))
end

uri = URI.parse('http://api.netatmo.net/api/getmeasure?')
response = Net::HTTP.post_form(uri, {
  'access_token' => 'ACCESS_TOKEN_HERE',
  'device_id' => 'DEVICE_ID_HERE',
  'scale' => '30min',
  'type' => 'Temperature',
  'limit' => '1'})
print JSON.parse response.body
