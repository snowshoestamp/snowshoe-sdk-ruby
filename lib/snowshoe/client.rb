module Snowshoe
  class Client
    API_VERSION = "https://api.snowshoestamp.com/v3/stamp"

    def initialize(key, options={})
      # Flexiblity for future endpoint uri changes
      api_version = options[:api_version] || API_VERSION
      @url = URI(api_version)

      @consumer = Net::HTTP.new(url.host, url.port);
      consumer.use_ssl = true
      @api_key = key

    end

    def post(body)
      request = Net::HTTP::Post.new(url)
      request["SnowShoe-Api-Key"] = api_key
      request["Content-Type"] = "application/json"
      request.body = body

      @response = consumer.request(request)
      return JSON.parse(response.read_body)
      
    rescue => exception
      log_error(exception.message)
      []
    end

    def log_error(message)
      puts "ERROR: #{self.class}: #{message}"
      puts "RESPONSE: #{response.inspect}"
    end

    private
    attr_reader :consumer, :api_key, :url, :response
  end
end
