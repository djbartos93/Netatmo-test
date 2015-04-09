require 'net/https'
require 'uri'
require 'yaml'
require 'json'
require 'sinatra'
#this file is for testing api calls before placing them into the proper file

CONFIG_FILE = 'config.yaml'
TOKEN_FILE = '.token.yaml'

######## API Auth #########
#begin authentication section
#config sets up the config.yml file

def config
  @config ||= YAML.load_file(CONFIG_FILE)['netatmo']
end

#get_token makes the api call to netatmo

def get_token
  puts "getting token"
  uri = URI.parse("http://api.netatmo.net/oauth2/token")
  JSON.parse Net::HTTP.post_form(uri, {
    'grant_type' => 'password',
    'client_id' => config['client_id'],
    'client_secret' => config['client_secret'],
    'username' => config['username'],
    'password' => config['password'],
    'scope' => 'read_station'
  }).body
end

#renew_token, following the API guidelines using the refresh token to get a new token when token expires.

def renew_token(refresh_token)
  uri = URI.parse("http://api.netatmo.net/oauth2/token")
  JSON.parse Net::HTTP.post_form(uri, {
    'grant_type' => 'refresh_token',
    'refresh_token' => refresh_token,
    'client_id' => config['client_id'],
    'client_secret' => config['client_secret']}).body
end

#save_token will save the token to the .token.yaml file (TOKEN_FILE)

def save_token(token_info)
  puts "checking token"
  @token = get_token
  token_info['timestamp'] = Time.now
  token_file = File.open TOKEN_FILE, 'w'
  token_file.write YAML.dump token_info
  token_file.flush
  token_file.close
end

#check_token should be checking if the token is expired or not.
#this currently fucks up when the token file isnt there
def check_token(token_to_check)
  if token_to_check['timestamp'] + token_to_check['expires_in'] < Time.now
    token_to_check = renew_token token_to_check['refresh_token']
    save_token token_to_check
  end
  token_to_check
end

#token is combinig everything to actually get the token, it will also refresh token when expired
#call this each time, if the token is good it shouldnt do anything
def token
  begin
    @token ||= YAML.load_file TOKEN_FILE
  rescue Exception
    @token = get_token
    save_token @token
  end

  check_token @token
end


######## API Data #########
#this gets all of the device info and puts it into the device.yaml file

def get_device
  puts "getting device info..."

  uri = URI.parse('http://api.netatmo.net/api/devicelist')

  JSON.parse(Net::HTTP.post_form(uri, {
    'access_token' => token['access_token']
  }).body)['body']
end

#gets outdoor_temp
def outdoor_temp(device_id)
  puts "getting current outdoor temperature (c)..."

  uri = URI.parse('http://api.netatmo.net/api/getmeasure')

  JSON.parse(Net::HTTP.post_form(uri, {
    'access_token' => token['access_token'],
    'device_id' => get_device['main_device'],
    'module_id' => get_device['modules'][device_id]['_id'],
    'date_end' => 'last',
    'scale' => 'max',
    'type' => 'temperature',
    'real_time' => 'true'
  }).body)['body']
end

#gets indoor_temp
def indoor_temp
  puts "getting current indoor temperature (c)..."

  uri = URI.parse('http://api.netatmo.net/api/getmeasure')

  JSON.parse(Net::HTTP.post_form(uri, {
    'access_token' => token['access_token'],
    'device_id' => get_device['modules'][0]['main_device'],
    'module_id' => get_device['devices'][0]['_id'],
    'date_end' => 'last',
    'scale' => 'max',
    'type' => 'temperature',
    'real_time' => 'true'
  }).body)['body']
end

#gets outdoor humidity
def outdoor_humidity(device_id)
  puts "getting current outdoor humidity..."

  uri = URI.parse('http://api.netatmo.net/api/getmeasure')

  JSON.parse(Net::HTTP.post_form(uri, {
  'access_token' => token['access_token'],
  'device_id' => get_device['modules'][0]['main_device'],
  'module_id' => get_device['modules'][device_id]['_id'],
  'date_end' => 'last',
  'scale' => 'max',
  'type' => 'humidity',
  'real_time' => 'true'
  }).body)['body']
end

#gets indoor humidity
def indoor_humidity
  puts "getting current indoor humidity..."

  uri = URI.parse('http://api.netatmo.net/api/getmeasure')

  JSON.parse(Net::HTTP.post_form(uri, {
  'access_token' => token['access_token'],
  'device_id' => get_device['modules'][0]['main_device'],
  'module_id' => get_device['devices'][0]['_id'],
  'date_end' => 'last',
  'scale' => 'max',
  'type' => 'humidity',
  'real_time' => 'true'
  }).body)['body']
end

def test_data
  get_device['modules'][0]['dashboard_data']
end

get '/' do
#  @indoor_temp = indoor_temp[0]
#  @outdoor_temp = outdoor_temp 0
#  @indoor_humidity = indoor_humidity
#  @outdoor_humidity = outdoor_humidity 0
  @test = test_data

  # Get alerts if any
  @alerts = get_device['devices'][0]['meteo_alarms']

  erb :measure
end




# Get main device from module at index 0
#puts get_device['modules'][0]['_id']

# Readable time
#Time.at(1428458280).asctime
