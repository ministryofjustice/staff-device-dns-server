require_relative "spec_helper"

describe BindClient do
  before do
    stub_request(:get, "localhost:8080/json/v1/server").to_return(status: 200, body: "{\"json-stats-version\": \"1.5\"}", headers: {})
  end

  it "get basic server stats" do
    expect(described_class.new.get_server_stats).to eq({"json-stats-version" => "1.5"})
  end
end
