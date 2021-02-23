class ApiChecker
  attr_reader :sleep_seconds

  SECONDS_TO_SLEEP_BETWEEN_CHECKS = 1
  NUMBER_OF_API_CHECKS = 10

  def initialize(sleep_seconds: SECONDS_TO_SLEEP_BETWEEN_CHECKS)
    @sleep_seconds = sleep_seconds
  end

  def execute
    is_up = false

    NUMBER_OF_API_CHECKS.times do
      BindClient.new.get_server_stats
    rescue Errno::EADDRNOTAVAIL
      sleep sleep_seconds
      next # Server is still booting so try again
    else
      is_up = true
      break # Server is up so we can continue
    end

    raise DnsStatsApiDidNotStartError.new("BIND Stats API is not running") unless is_up

    is_up
  end

  private

  class DnsStatsApiDidNotStartError < StandardError; end
end
