require 'rubygems'
require 'net/https'
require 'uri'
require 'json'
require 'yaml'

CONFIG_FILE = 'config.yml'
TOKEN_FILE = '.token.yaml'

def config
  @config ||= YAML.load_file(CONFIG_FILE)['netatmo']
end

def renew
  @renew ||= YAML.load_file(TOKEN_FILE)
end

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

def toke_renew
  uri = URI.parse("http://api.netatmo.net/oauth2/token")
  JSON.parse Net::HTTP.post_form(uri, {
    'grant_type' => 'refresh_token',
    'refresh_token' => renew['refresh_token'],
    'client_id' => config['client_id'],
    'client_secret' => config['client_secret']})
end

def save_token(token_info)
  @token = get_token
  token_info['timestamp'] = Time.now
  token_file.write YAML.dump token_info
  token_file.flush
  token_file.close
end

def token
  begin
    @token ||= YAML.load_file TOKEN_FILE
  rescue Exception
    @token = nil
  end
  if !@token || @token['timestamp'] + @token['expires_in'] < Time.now
    @token = renew_token
    save_token @token
  end
  @token
end

puts token['access_token']
