require "time"

class PublishMetrics
  def initialize(client:)
    @client = client
    @time = DateTime.now.to_time.to_i
  end

  def execute(server_stats:, zone_stats:)
    raise "BIND server stats are empty" if server_stats.empty?
    raise "BIND zones stats are empty" if zone_stats.empty?

    client.put_metric_data(generate_cloudwatch_metrics(server_stats) + generate_zone_metrics(zone_stats))
  end

  private

  def generate_cloudwatch_metrics(server_stats)
    return [] unless server_stats.has_key?("nsstats")

    server_stats["nsstats"].map { |key, value| generate_metric(key, value) }.compact
  end

  def generate_zone_metrics(zone_stats)
    return [] unless zone_stats.dig("views", "_default", "zones")

    value = zone_stats["views"]["_default"]["zones"].count
    [generate_metric("ConfiguredRecords", value)]
  end

  def generate_metric(key, value)
    {dimensions: [], metric_name: key, timestamp: @time, value: value}
  end

  attr_reader :client
end
