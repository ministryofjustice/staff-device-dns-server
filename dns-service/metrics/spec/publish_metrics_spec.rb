require_relative "spec_helper"

describe PublishMetrics do
  let(:client) { spy }
  let!(:time) { DateTime.now.to_time }
  let(:timestamp) { time.to_i }

  before do
    Timecop.freeze(time)
  end

  after do
    Timecop.return
  end

  it "raises an error if the BIND stats is empty" do
    expect {
      described_class.new(
        client: client
      ).execute(server_stats: {}, zone_stats: {test: "test"})
    }.to raise_error("BIND server stats are empty")
  end

  it "converts BIND stats to cloudwatch metrics and calls the client to publish them" do
    server_stats = JSON.parse(File.read("#{RSPEC_ROOT}/fixtures/bind_api_server_stats_response.json"))

    result = described_class.new(
      client: client
    ).execute(server_stats: server_stats, zone_stats: {test: "test"})

    expected_result = [
      {
        metric_name: "Requestv4",
        timestamp: timestamp,
        value: 10,
        dimensions: []
      },
      {
        metric_name: "Response",
        timestamp: timestamp,
        value: 10,
        dimensions: []
      },
      {
        metric_name: "QrySuccess",
        timestamp: timestamp,
        value: 4,
        dimensions: []
      },
      {
        metric_name: "QryNoauthAns",
        timestamp: timestamp,
        value: 8,
        dimensions: []
      },
      {
        metric_name: "QryNxrrset",
        timestamp: timestamp,
        value: 1,
        dimensions: []
      },
      {
        metric_name: "QrySERVFAIL",
        timestamp: timestamp,
        value: 2,
        dimensions: []
      },
      {
        metric_name: "QryNXDOMAIN",
        timestamp: timestamp,
        value: 3,
        dimensions: []
      },
      {
        metric_name: "QryRecursion",
        timestamp: timestamp,
        value: 10,
        dimensions: []
      },
      {
        metric_name: "QryUDP",
        timestamp: timestamp,
        value: 10,
        dimensions: []
      }
    ]

    expect(client).to have_received(:put_metric_data).with(match_array(expected_result))
  end

  it "raises an error if the BIND zones stats is empty" do
    expect {
      described_class.new(
        client: client
      ).execute(zone_stats: {}, server_stats: {test: "test"})
    }.to raise_error("BIND zones stats are empty")
  end

  it "converts BIND zones stats to cloudwatch metrics and calls the client to publish them" do
    zone_stats = JSON.parse(File.read("#{RSPEC_ROOT}/fixtures/bind_api_zone_stats_response.json"))

    result = described_class.new(
      client: client
    ).execute(server_stats: {test: "test"}, zone_stats: zone_stats)

    expected_result = [
      {
        metric_name: "ConfiguredRecords",
        timestamp: timestamp,
        value: 2,
        dimensions: []
      }
    ]

    expect(client).to have_received(:put_metric_data).with(match_array(expected_result))
  end
end
