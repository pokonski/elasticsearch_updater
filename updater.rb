require 'bundler/setup'
require 'unirest'
require 'dotenv'
require "yajl"

Dotenv.load

ATTRIBUTES = {
  something_dummy: 123
}

HOST = ENV["ES_HOST"]
PORT = ENV["ES_PORT"]
INDEX = ENV["ES_INDEX"]
BASE_URL = "http://#{HOST}:#{PORT}/#{INDEX}"
PAGE = 10


index = 1
current = 1
total_count = Unirest.get("#{BASE_URL}/_count").body["count"]

while true
  response = Unirest.get("#{BASE_URL}/_search?fields=&from=#{index}&size=#{PAGE}").body
  results = response["hits"]["hits"]
  break if results.empty?

  results.each do |result|
    Unirest.post "#{BASE_URL}/#{result["_id"]}/_update",
                parameters: Yajl::Encoder.encode({doc: ATTRIBUTES}) do |response|
      current += 1
      puts "Updated #{current}/#{total_count}"
    end
  end
  index += PAGE
end