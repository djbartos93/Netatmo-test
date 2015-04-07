require 'net/https'
require 'uri'
require 'yaml'
require 'json'
require 'sinatra'
#this file is for testing api calls before placing them into the proper file

CONFIG_FILE = 'config.yml'
TOKEN_FILE = '.token.yaml'
USER_FILE = 'user.yaml'
DEVICE_FILE = 'device.yaml'
OUTDOOR_TEMP = 'outdoor_temp.yaml'
INDOOR_TEMP = 'indoor_temp.yaml'
OUTDOOR_HUMID = 'outdoor_humid.yaml'
INDOOR_HUMID = 'indoor_humid.yaml'

def measure_config
  @measure_config ||= YAML.load_file(TOKEN_FILE)
end

def read_config_modules
  @read_config ||= YAML.load_file(DEVICE_FILE)['body']['modules'][0]
end

def read_config_indoor
  @read_config ||= YAML.load_file(DEVICE_FILE)['body']['devices'][0]
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

#gets outdoor_temp

def outdoor_temp
  File.open TOKEN_FILE
  puts "getting current outdoor temperature (c)..."
  time= Time.now.utc.nsec
  uri = URI.parse('http://api.netatmo.net/api/getmeasure')
  temp_out = JSON.parse Net::HTTP.post_form(uri, {
  'access_token' => measure_config['access_token'],
  'device_id' => read_config_modules['main_device'],
  'module_id' => read_config_modules['_id'],
  'date_end' => 'last',
  'scale' => 'max',
  'type' => 'temperature',
  'real_time' => 'true'
  }).body
  temp_file = File.open(OUTDOOR_TEMP, 'w')
  temp_file.write YAML.dump temp_out
end

#gets indoor_temp

def indoor_temp
  File.open TOKEN_FILE
  puts "getting current indoor temperature (c)..."
  time= Time.now.utc.nsec
  uri = URI.parse('http://api.netatmo.net/api/getmeasure')
  temp_in = JSON.parse Net::HTTP.post_form(uri, {
  'access_token' => measure_config['access_token'],
  'device_id' => read_config_modules['main_device'],
  'module_id' => read_config_indoor[['modules']],
  'date_end' => 'last',
  'scale' => 'max',
  'type' => 'temperature',
  'real_time' => 'true'
  }).body
  temp_file = File.open(INDOOR_TEMP, 'w')
  temp_file.write YAML.dump temp_in
end

#gets outdoor humidity

def outdoor_humidity
  File.open TOKEN_FILE
  puts "getting current outdoor humidity..."
  time= Time.now.utc.nsec
  uri = URI.parse('http://api.netatmo.net/api/getmeasure')
  humid_out = JSON.parse Net::HTTP.post_form(uri, {
  'access_token' => measure_config['access_token'],
  'device_id' => read_config_modules['main_device'],
  'module_id' => read_config_modules['_id'],
  'date_end' => 'last',
  'scale' => 'max',
  'type' => 'humidity',
  'real_time' => 'true'
  }).body
  temp_file = File.open(OUTDOOR_HUMID, 'w')
  temp_file.write YAML.dump humid_out
end

#gets indoor humidity

def indoor_humidity
  File.open TOKEN_FILE
  puts "getting current indoor humidity..."
  time= Time.now.utc.nsec
  uri = URI.parse('http://api.netatmo.net/api/getmeasure')
  humid_in = JSON.parse Net::HTTP.post_form(uri, {
  'access_token' => measure_config['access_token'],
  'device_id' => read_config_modules['main_device'],
  'module_id' => read_config_indoor[['modules']],
  'date_end' => 'last',
  'scale' => 'max',
  'type' => 'humidity',
  'real_time' => 'true'
  }).body
  return humid_in['body'][0]
end

def data
  humid_inside = indoor_humidity['body'][0]
end

def temp_output
  @temp_output ||= YAML.load_file(OUTDOOR_TEMP)['body'][0]
  puts @temp_output['value']
end


def dashboard_data_out
  File.open TOKEN_FILE
  puts "getting dashboard data..."
  uri = URI.parse('http://api.netatmo.net/api/devicelist')
  dashboard = JSON.parse Net::HTTP.post_form(uri, {
    'access_token' => measure_config['access_token']
    }).body
  @out = dashboard['body']['modules'][0]
  @in = dashboard['body']['devices'][0]
  @outdoor_data = @out["dashboard_data"]
end

def dashboard_data_in
  File.open TOKEN_FILE
  puts "getting dashboard data..."
  uri = URI.parse('http://api.netatmo.net/api/devicelist')
  dashboard = JSON.parse Net::HTTP.post_form(uri, {
    'access_token' => measure_config['access_token']
    }).body
  @out = dashboard['body']['modules'][0]
  @in = dashboard['body']['devices'][0]
  @indoor_data = @in["dashboard_data"]
end

get '/' do
  "#{@data_outside = dashboard_data_out}"
  "#{@data_inside = dashboard_data_in}"
  erb :measure
end

=begin
puts get_user
puts get_device
puts indoor_temp
puts indoor_humidity
puts outdoor_humidity
puts outdoor_temp
=end

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
