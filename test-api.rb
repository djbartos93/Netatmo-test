require 'net/https'
require 'uri'
require 'yaml'
require 'json'
#this file is for testing api calls before placing them into the proper file

CONFIG_FILE = 'config.yml'
TOKEN_FILE = '.token.yaml'
USER_FILE = 'user.yaml'

def measure_config
  @measure_config ||= YAML.load_file(TOKEN_FILE)
end

#get user and save info to file

def getuser
  File.open TOKEN_FILE
  uri = URI.parse('http://api.netatmo.net/api/getuser')
  user_info = JSON.parse Net::HTTP.post_form(uri, {
  'access_token' => measure_config['access_token']}).body
  user_file = File.open(USER_FILE, 'w')
  user_file.write YAML.dump user_info
end


puts measure_config
puts getuser
=begin
uri = URI.parse('http://api.netatmo.net/api/getmeasure?')
JSON.parse Net::HTTP.post_form(uri, {
  'access_token' => ['access_token'],
  'device_id' => 'DEVICE_ID_HERE',
  'scale' => '30min',
  'type' => 'Temperature',
  'limit' => '1'})
print JSON.parse response.body
=end
