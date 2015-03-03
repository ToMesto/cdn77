require "spec_helper"

shared_examples "an url builder" do
  it "should raise ArgumentError when scope is nil" do
     expect{ cdn.url(nil, "details") }.to raise_error(ArgumentError, "Scope could not be empty")
  end

  it "should raise ArgumentError when method is nil" do
    expect{ cdn.url("account", nil) }.to raise_error(ArgumentError, "Method could not be empty")
  end

  it "should raise ArgumentError when configuration in not specified" do
    allow(Cdn77).to receive(:configuration).and_return(nil)
    expect{ cdn.url("account", "details") }.to raise_error(ArgumentError, "Configuration endpoint was not specified")
  end
end

describe Cdn77::CDN do
  before do
    Cdn77.configure do |config|
      config.login = "ivan@examle.com"
      config.password = "secret"
    end
  end

  let (:cdn) { Cdn77.cdn }
  let (:url) { "https://client.cdn77.com/api/v2.0/account/details" }
  let (:url_with_credentials) { "https://client.cdn77.com/api/v2.0/account/details?login=ivan@examle.com&password=secret" }
  let (:successful_response_body) do
    { 
      :status => "ok", 
      :description => "Request was successful." 
    }
  end
  let (:wrong_credentials_response_body) do
    { 
      :status => "error", 
      :description => "Authentication failed. Please, login again or contact our support." 
    }
  end
  let (:wrong_parameters_response_body) do
    {
      :status => "error", 
      :description => "Request was not successful.", 
      :errors => {
        :email => "email is required.", 
        :password => "password is required."
      }
    }
  end

  describe "#url" do
    it { is_expected.to respond_to(:url) }
    
    it_behaves_like "an url builder"

    it "should return correct url with scope and method" do
      expect(cdn.url("account", "details")).to eq(url)
    end

    it "should add given params to url" do
      expect(cdn.url("account", "details", :test => "test")).to eq(url + "?test=test")
    end
  end

  describe "#get" do
    it { is_expected.to respond_to(:get) }

    it_behaves_like "an url builder"

    it "should raise MethodCallError when response code is not 200 OK" do
      stub_request(:get, url_with_credentials).to_return(:status => 500, :body => successful_response_body.to_json)
      expect{ cdn.get("account", "details") }.to raise_error(Cdn77::MethodCallError)
    end

    it "should raise MethodCallError when response body is empty" do
      stub_request(:get, url_with_credentials).to_return(:status => 500, :body => '')
      expect{ cdn.get("account", "details") }.to raise_error(Cdn77::MethodCallError)
    end

    it "should raise MethodCallError when response status is not ok" do
      stub_request(:get, url_with_credentials).to_return(:status => 200, :body => wrong_parameters_response_body.to_json)
      expect{ cdn.get("account", "details") }.to raise_error(Cdn77::MethodCallError)
    end

    it "should raise MethodCallError when wrong creditinals reported" do
      stub_request(:get, url_with_credentials).to_return(:status => 200, :body => wrong_credentials_response_body.to_json)
      expect{ cdn.get("account", "details") }.to raise_error(Cdn77::MethodCallError, wrong_credentials_response_body[:description])
    end

    it "should return response body as a hash if no block given" do
      stub_request(:get, url_with_credentials).to_return(:status => 200, :body => successful_response_body.to_json)
      expect(cdn.get("account", "details")).to eq(successful_response_body)
    end

    it "should pass response body as a hash into given block" do
      stub_request(:get, url_with_credentials).to_return(:status => 200, :body => successful_response_body.to_json)
      expect{ |block| cdn.get("account", "details", &block) }.to yield_with_args(successful_response_body)
    end

    it "should send get request with login and password" do
      stub_request(:get, url_with_credentials).to_return(:status => 200, :body => successful_response_body.to_json)
      cdn.get("account", "details")
      expect(WebMock).to have_requested(:get, url_with_credentials)
    end
  end
end