require 'blasphemy'
require 'httparty'
require 'json'

class EventCreator
  include HTTParty

  format :json
  headers 'Accept' => 'application/json'

  attr_accessor :service_key, :base_uri

  def initialize(host, service)
    @service_key = service
    @base_uri = host
  end

  def generate_event
    bacon = Faker::BaconIpsum.new
    sam = Faker::SamuelLIpsum.new
    { :service_key => @service_key,
      :event_type => 'trigger',
      :description => bacon.sentence,
      :details => {
        :quote => sam.paragraph
      }
    }.to_json
  end

  def post
    puts "POSTing to #{@base_uri}..."
  	self.class.post(URI.join(@base_uri, '/generic/2010-04-15/create_event.json').to_s, {
      :body => generate_event 
  	})
  end

end