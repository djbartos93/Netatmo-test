require 'net/https'
require 'uri'
require 'yaml'
require 'json'
#this file is for testing api calls before placing them into the proper file

CONFIG_FILE = 'config.yml'
TOKEN_FILE = '.token.yaml'
USER_FILE = 'user.yaml'
DEVICE_FILE = 'device.yaml'
MEASURE_FILE = 'outdoor_temp.yaml'

def measure_config
  @measure_config ||= YAML.load_file(TOKEN_FILE)
end

def read_config
  @read_config ||= YAML.load_file(DEVICE_FILE)['body']
end

#get user and save info to file

def get_user
  File.open TOKEN_FILE
  puts "getting user info..."
  uri = URI.parse('http://api.netatmo.net/api/getuser')
  user_info = JSON.parse Net::HTTP.post_form(uri, {
  'access_token' => measure_config['access_token']}).body
  user_file = File.open(USER_FILE, 'w')
  user_file.write YAML.dump user_info
  user_file.flush
  user_file.close
end

#this gets all of the device info and puts it into the device.yaml file
#this DOES NOT provide the most up to date measurements

def get_device
  File.open TOKEN_FILE
  puts "getting device info..."
  uri = URI.parse('http://api.netatmo.net/api/devicelist')
  device_info = JSON.parse Net::HTTP.post_form(uri, {
  'access_token' => measure_config['access_token']
  }).body
  device_file = File.open(DEVICE_FILE, 'w')
  device_file.write YAML.dump device_info
  device_file.flush
  device_file.close
end

def outdoor_temp
  File.open TOKEN_FILE
  puts "getting current temperature (c)..."
  uri = URI.parse('http://api.netatmo.net/api/getmeasure')
  temp_info = JSON.parse Net::HTTP.post_form(uri, {
  'access_token' => measure_config['access_token'],
  'device_id' => '70:ee:50:06:02:1c',
  'module_id' => '02:00:00:06:05:6c',
  'scale' => 'max',
  'type' => 'temperature',
  'real_time' => 'true'
  }).body
  temp_file = File.open(MEASURE_FILE, 'w')
  temp_file.write YAML.dump temp_info
end

puts outdoor_temp

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
