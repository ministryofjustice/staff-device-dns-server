require_relative "dns_metrics"

ApiChecker.new.execute

loop do
  PublishMetrics.new(
    aws_client: AwsClient.new,
    bind_client: BindClient.new
  ).execute
  sleep 10
end
