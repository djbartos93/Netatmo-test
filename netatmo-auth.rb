require 'rubygems'
require 'net/https'
require 'uri'

#use this to get your access token. its rather ugly but it works.

uri = URI.parse("http://api.netatmo.net/oauth2/token")
response = Net::HTTP.post_form(uri, {
  'grant_type' => 'password',
  'client_id' => 'CLIENT_ID_HERE',
  'client_secret' => 'CLIENT_SECRET_HERE',
  'username' => 'NETATMO_ACCOUNT_EMAIL',
  'password' => 'NETATMO_PASSWORD',
  'scope' => 'read_station or SEE API DOCS'})

puts response.body
