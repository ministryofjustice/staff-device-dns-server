require "sentry-ruby"
require_relative "dns_metrics"

Sentry.init do |config|
  # All errors will be sent syncronously!
  config.background_worker_threads = 0
  config.environment = ENV["SENTRY_CURRENT_ENV"]
end

class Agent
  def execute
    api_checker.execute

    loop do
      PublishMetrics.new(
        aws_client: aws_client,
        bind_client: bind_client
      ).execute
      sleep 10
    end
  rescue => e
    Sentry.capture_exception(e)
    raise e
  end

  private

  def api_checker
    @api_checker ||= ApiChecker.new
  end

  def aws_client
    @aws_client ||= AwsClient.new
  end

  def bind_client
    @bind_client ||= BindClient.new
  end
end

Agent.new.execute
