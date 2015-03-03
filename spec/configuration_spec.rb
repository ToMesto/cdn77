require "spec_helper"

describe Cdn77::Configuration do
  it { is_expected.to respond_to(:login, :password, :endpoint) }

  it "should return default endpoint if another was not given" do
    expect(Cdn77::Configuration.new.endpoint).to eq(Cdn77::Configuration::DEFAULT_ENDPOINT)
  end

  it "should return provided endpoint" do
    expect(Cdn77::Configuration.new(:endpoint => "https://exmaple.com").endpoint).to eq("https://exmaple.com")
  end

  it "should return provided login and password" do
    config = Cdn77::Configuration.new(:login => "ivan@example.com", :password => "secret")
    expect(config.login).to eq("ivan@example.com")
    expect(config.password).to eq("secret")
  end
end