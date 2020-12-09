class ApiChecker
  attr_reader :sleep_seconds

  def initialize(sleep_seconds: 1)
    @sleep_seconds = sleep_seconds
  end

  def execute
    is_up = false

    10.times do
      BindClient.new.get_server_stats
    rescue Errno::EADDRNOTAVAIL
      sleep sleep_seconds
      next # Server is still booting so try again
    else
      is_up = true
      break # Server is up so we can continue
    end

    raise "BIND Stats API is not running" unless is_up

    is_up
  end
end
