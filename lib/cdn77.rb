require "cdn77/version"
require "json"

module Cdn77
  autoload :Account, "cdn77/account"
  autoload :Configuration, "cdn77/configuration"

  def self.cdn(configuration = nil)
    CDN.new(configuration)
  end

  class MethodCallError < StandardError; end;

  class CDN
    include Cdn77::Account

    def initialize(configuration = nil)
      @configuration = configuration
    end

    def configuration
      @configuration || Cdn77.configuration
    end

    def login
      configuration.login
    end

    def password
      configuration.password
    end

    def headers
      {
        "Accept" => "application/json",
        "Content-Type" =>"application/json"
      }
    end

    def get(scope, method, params = {})
      raise ArgumentError, "Scope could not be empty" if scope.nil? || scope.empty?
      raise ArgumentError, "Method could not be empty" if method.nil? || method.empty?
      params ||= {}
      params[:login] ||= login
      params[:passwd] ||= password
      uri = URI(url(scope, method, params))
      http = Net::HTTP.new(uri.host,uri.port)
      http.use_ssl = true
      response = http.get(uri.request_uri, headers)
      raise MethodCallError, response.body unless response.is_a?(Net::HTTPSuccess)
      body = response.body
      raise MethodCallError, 'Response could not be empty' if body.nil? || body.empty?
      json = JSON.parse(body, :symbolize_names => true)
      if json[:status] == "ok"
        block_given? ? yield(json) : json
      else
        message = [ json[:description].to_s ]
        message += json[:errors].map { |field, description| "#{field}: #{description}" } if json[:errors]
        raise MethodCallError, message.join(". ")
      end
    end

    def url(scope, method, params = {})
      raise ArgumentError, "Scope could not be empty" if scope.nil? || scope.empty?
      raise ArgumentError, "Method could not be empty" if method.nil? || method.empty?
      raise ArgumentError, "Configuration endpoint was not specified" if configuration.nil? || configuration.endpoint.nil? || configuration.endpoint.empty? 
      url = configuration.endpoint + "/#{scope}/#{method}"
      url += "?#{URI.encode_www_form(params)}" if params && params.any?
      url
    end
  end

  class << self
    attr_accessor :configuration
  end

  def self.reset_configuration
    self.configuration = nil
  end
  
  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end
end
