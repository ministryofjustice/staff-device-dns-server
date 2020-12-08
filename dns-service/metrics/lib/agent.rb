require_relative "dns_metrics"

# Wait for DNS server to start
10.times do
  BindClient.new.get_server_stats
rescue Errno::EADDRNOTAVAIL => e
  sleep 1
  next # Server is still booting so try again
else
  break # Server is up so we can continue
end

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
