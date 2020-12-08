require_relative "spec_helper"

describe BindClient do
  describe "#get_server_stats" do
    before do
      stub_request(:get, "localhost:8080/json/v1/server").to_return(status: 200, body: "{\"json-stats-version\": \"1.5\"}", headers: {})
    end

    it "get basic server stats" do
      expect(described_class.new.get_server_stats).to eq({"json-stats-version" => "1.5"})
    end
  end

  describe "#get_zone_stats" do
    before do
      zone_body = "{\"views\":{\"_default\":{\"zones\":[{\"name\":\"test1.example.com\"},{\"name\":\"test2.localhost\"}]}}}"
      stub_request(:get, "localhost:8080/json/v1/zones").to_return(status: 200, body: zone_body, headers: {})
    end

    it "get BIND zone stats" do
      expect(described_class.new.get_zone_stats).to eq(
        {
          "views" => {
            "_default" => {
              "zones" => [
                {"name"=>"test1.example.com"},
                {"name"=>"test2.localhost"}
              ]
            }
          }
        }
      )
    end
  end
end
