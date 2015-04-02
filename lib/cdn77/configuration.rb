module Cdn77
  class Configuration
    DEFAULT_ENDPOINT = "https://api.cdn77.com/v2.0"

    attr_accessor :login
    attr_accessor :password
    attr_accessor :endpoint

    def initialize(params = nil)
      params ||= {}
      self.login = params[:login]
      self.password = params[:password]
      self.endpoint = params[:endpoint] || DEFAULT_ENDPOINT
    end
  end
end