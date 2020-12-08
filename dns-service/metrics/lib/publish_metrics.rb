require "time"

class PublishMetrics
  def initialize(client:)
    @client = client
    @time = DateTime.now.to_time.to_i
  end

  def execute(server_stats:)
    raise "BIND stats are empty" if server_stats.empty?

    client.put_metric_data(generate_cloudwatch_metrics(server_stats))
  end

  private

  def generate_cloudwatch_metrics(server_stats)
    return [] unless server_stats.has_key?("nsstats")

    server_stats["nsstats"].map { |key, value| generate_metric(key, value) }.compact
  end

  def generate_metric(key, value)
    {dimensions: [], metric_name: key, timestamp: @time, value: value}
  end

  attr_reader :client
end
