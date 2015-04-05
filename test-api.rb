require 'net/https'
require 'uri'
require 'yaml'
require 'json'
#this file is for testing api calls before placing them into the proper file

CONFIG_FILE = 'config.yml'
TOKEN_FILE = '.token.yaml'
USER_FILE = 'user.yaml'
DEVICE_FILE = 'device.yaml'
MEASURE_FILE = 'measurements.yaml'

def measure_config
  @measure_config ||= YAML.load_file(TOKEN_FILE)
end

def read_config
  @read_config ||= YAML.load_file(DEVICE_FILE)['modules']
end

#get user and save info to file

def get_user
  File.open TOKEN_FILE
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
  uri = URI.parse('http://api.netatmo.net/api/devicelist')
  device_info = JSON.parse Net::HTTP.post_form(uri, {
  'access_token' => measure_config['access_token']
  }).body
  device_file = File.open(DEVICE_FILE, 'w')
  device_file.write YAML.dump device_info
  device_file.flush
  device_file.close
end

def current_temp
  File.open TOKEN_FILE
  File.open DEVICE_FILE
  uri = URI.parse('http://api.netatmo.net/api/getmeasure')
  current_temp = JSON.parse Net::HTTP.post_form(uri, {
  'access_token' => measure_config['access_token'],
  'device_id' => read_config['main_device'],
  'module_id' => read_config['main_device'],
  'scale' => '30min',
  'type' => 'temperature',
  'limit' => '1'})
  temp_file = File.open(MEASURE_FILE)
  temp_file.write YAML.dump current_temp
  temp_file.flush
  temp_file.close
end

puts get_user
puts get_device
puts current_temp
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
