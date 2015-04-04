require 'rubygems'
require 'net/https'
require 'uri'
require 'json'
require 'yaml'

#parsed = begin
#  YAML.load(FIle.open("/config/local_env.yml"))
#end


uri = URI.parse("http://api.netatmo.net/oauth2/token")
response = Net::HTTP.post_form(uri, {
  'grant_type' => 'refresh_token',
  'refresh_token' => '551bf627485a88d073777dad|467429a377be4665d24d7f2e6ab68a5c',
  'client_id' => '551c7f7e207759837ac379ee',
  'client_secret' => 'JtQneo4Mw5yALA1GOSNH2SidvDYCVm1b4H'})
puts response.body

output = File.open('/config/local_env.yml', 'w')
output.puts YAML.dump(JSON.parse response.body)
