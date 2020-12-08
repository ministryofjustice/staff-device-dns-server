require "time"

class PublishMetrics
  def initialize(aws_client:, bind_client:)
    @aws_client = aws_client
    @bind_client = bind_client
    @time = DateTime.now.to_time.to_i
  end

  def execute
    server_stats = bind_client.server_stats
    zone_stats = bind_client.zone_stats

    raise "BIND server stats are empty" if server_stats.empty?
    raise "BIND zones stats are empty" if zone_stats.empty?

    aws_client.put_metric_data(generate_cloudwatch_metrics(server_stats) + generate_zone_metrics(zone_stats))
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

  attr_reader :aws_client, :bind_client
end
