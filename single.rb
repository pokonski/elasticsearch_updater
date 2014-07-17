require 'bundler/setup'
require 'unirest'
require 'dotenv'
require "yajl"

Dotenv.load

# TU USTAW WLASNY
DOCUMENT_ID = "bdefak4512T_"

ATTRIBUTES_TO_MERGE = {
  something_dummy: 123
}

HOST = ENV["ES_HOST"]
PORT = ENV["ES_PORT"]
INDEX = ENV["ES_INDEX"]
BASE_URL = "http://#{HOST}:#{PORT}/#{INDEX}"



Unirest.post "#{BASE_URL}/#{DOCUMENT_ID}/_update",
            parameters: Yajl::Encoder.encode({doc: ATTRIBUTES_TO_MERGE}) do |response|
  puts "Updated #{DOCUMENT_ID}"
end
