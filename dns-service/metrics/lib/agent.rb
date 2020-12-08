require_relative "dns_metrics"

while true
  puts "before metrics"
  server_stats = BindClient.new.get_server_stats
  zone_stats = BindClient.new.get_zone_stats
  PublishMetrics.new(
    client: AwsClient.new
  ).execute(server_stats: server_stats, zone_stats: zone_stats)
  puts "after metrics"
  sleep 10
end
