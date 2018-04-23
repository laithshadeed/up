# frozen_string_literal: true

require 'up/version'
require 'net/http'

PROBING_TIME = 60 # In Seconds
SLEEP_TIME = 10 # In Seconds

# Ping your server few times then return average response time
module Up
  class << self
    def run(uri)
      my_uri = parse_uri(uri)
      if my_uri.nil?
        puts "Invalid URI: #{uri}"
        return
      end

      iterations = PROBING_TIME / SLEEP_TIME
      start_time = Time.now
      puts "Start time #{start_time}"

      iterations.times do |i|
        puts "Pinging server ##{i + 1}"
        result = fetch(my_uri)
        if result != 200
          puts 'Opps.. Server response with non 200 code. Measurement aborted!'
          return
        else
          sleep SLEEP_TIME
        end
      end

      total_time = Time.now - start_time - iterations * SLEEP_TIME
      response_time = total_time / iterations
      puts "Server response time: #{response_time.round(2)}"
    end

    def parse_uri(uri)
      parsed = nil
      begin
        parsed = URI.parse(uri)
        parsed.path = '/' if parsed.path.empty?
        parsed = nil if parsed.scheme != 'http' && parsed.scheme != 'https'
      rescue StandardError => e
        puts e.inspect
      end

      parsed
    end

    def fetch(uri)
      result = nil
      begin
        Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
          http.request_get(uri) do |response|
            puts "Response code #{response.code}"
            result = 200 if response.code == '200'
          end
        end
      rescue StandardError => e
        puts e.inspect
      end

      result
    end
  end
end
