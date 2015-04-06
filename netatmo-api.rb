require 'rubygems'
require 'net/https'
require 'uri'
require 'json'
require 'yaml'

CONFIG_FILE = 'config.yaml'
TOKEN_FILE = '.token.yaml'

#begin authentication section
#config sets up the config.yml file

def config
  @config ||= YAML.load_file(CONFIG_FILE)['netatmo']
end

#get_token makes the api call to netatmo

def get_token
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

puts token['access_token']

#this ends the authentication section
