require 'rubygems'
require 'net/https'
require 'uri'
require 'json'
require 'yaml'

#parsed = begin
#  YAML.load(File.open("config-testing.yml"))
#end

file_content= YAML.load_file('config-testing.yml')
p file_content
