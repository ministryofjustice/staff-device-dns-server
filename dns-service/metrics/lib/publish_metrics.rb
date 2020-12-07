require "time"

class PublishMetrics
  def initialize(client:)
    @client = client
    @time = DateTime.now.to_time.to_i
  end

  def execute(bind_stats:)
    raise "BIND stats are empty" if bind_stats.empty?

    client.put_metric_data(generate_cloudwatch_metrics(bind_stats))
  end

  private

  def generate_cloudwatch_metrics(bind_stats)
    return [] unless bind_stats.has_key?("nsstats")

    bind_stats["nsstats"].map { |key, value| generate_metric(key, value) }.compact
  end

  def generate_metric(key, value)
    {dimensions: [], metric_name: key, timestamp: @time, value: value}
  end

  attr_reader :client
end
