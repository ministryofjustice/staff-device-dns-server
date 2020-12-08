require_relative "dns_metrics"

while true
  bind_stats = BindClient.new.get_server_stats
  puts "before metrics"
  PublishMetrics.new(
    client: AwsClient.new
  ).execute(bind_stats: bind_stats)
  puts "after metrics"
  sleep 10
end
