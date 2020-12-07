require_relative 'dns_metrics'

while true do
  bind_stats = BindClient.new.get_server_stats
  PublishMetrics.new(
    client: AwsClient.new,
    ).execute(bind_stats: bind_stats)
  sleep 10
end
