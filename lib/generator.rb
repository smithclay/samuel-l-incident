require 'blasphemy'
require 'httparty'
require 'json'
require 'faker'

class EventCreator
  include HTTParty

  format :json
  headers 'Accept' => 'application/json'

  attr_accessor :service_key, :base_uri

  def initialize(host, service, safe_for_work)
    @service_key = service
    @base_uri = host
    @sfw = safe_for_work
  end

  def generate_event
    bacon = Faker::BaconIpsum.new
    hacker = Faker::Hacker
    sam = Faker::SamuelLIpsum.new
    { :service_key => @service_key,
      :event_type => 'trigger',
      :description => hacker.say_something_smart,
      :contexts => [
        {
          'href' => 'http://www.pagerduty.com',
          'type' => 'link',
          'text' => 'Incident Report'
        },
        {
          'type' => 'image',
          'src' => 'https://chart.googleapis.com/chart?chs=451x180&chd=t:1,2,3,5,8,13,7&cht=lc&chds=a&chxt=y&chm=D,0033FF,0,0,5,1%22'
        }
      ],
      :details => {
        :mac_address => Faker::Internet.mac_address,
        :ip_addr => Faker::Internet.ip_v4_address,
        :quote => @sfw ? bacon.paragraph : sam.paragraph
      }
    }.to_json
  end

  def post
    uri = URI.join(@base_uri, '/generic/2010-04-15/create_event.json')
    puts "POSTing to #{uri.to_s}..."
    self.class.post(uri.to_s, { :body => generate_event })
  end

end