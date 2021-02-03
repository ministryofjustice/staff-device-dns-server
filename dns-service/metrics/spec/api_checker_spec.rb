require_relative "spec_helper"

describe ApiChecker do
  describe "#execute" do
    context "statistics API is up" do
      before do
        stub_request(:get, "localhost:8080/json/v1/server")
          .to_return(status: 200, body: "{\"json-stats-version\": \"1.5\"}", headers: {})
      end

      it "returns true" do
        expect(ApiChecker.new(sleep_seconds: 0).execute).to eq true
      end
    end

    context "statistics API is down" do
      before do
        stub_request(:get, "localhost:8080/json/v1/server")
          .to_raise(Errno::EADDRNOTAVAIL)
      end

      it "raises an error" do
        expect {
          ApiChecker.new(sleep_seconds: 0).execute
        }.to raise_error "BIND Stats API is not running"
      end
    end
  end
end
