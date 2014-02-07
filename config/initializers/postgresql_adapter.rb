class ::ActiveRecord::ConnectionAdapters::PostgreSQLAdapter
  # Reverting to Rails 3.x behavior.
  def active?
    @connection.query 'SELECT 1'
    true
  rescue PGError
    false
  end

  #### v
  RECONNECT_RETRY_TIMEOUT = 2
  RECONNECT_RETRY_INTERVAL = 0.25
  #### ^

  # Close then reopen the connection.
  #
  # Additonally, retry reconnecting (in case of a temporary outage), and
  # properly detect whether @connection.reset actually reconnected.
  def reconnect!
    super
    #### v
    raise PG::ConnectionBad, "Failed to reconnect after #{RECONNECT_RETRY_TIMEOUT} seconds" unless ArtemisRailsHacks.wait_while(RECONNECT_RETRY_TIMEOUT, RECONNECT_RETRY_INTERVAL) do
      Rails.logger.warn("Reconnect attempt")
      @connection.reset
      @connection.status == PGconn::CONNECTION_OK
    end
    #### ^
    configure_connection
  end
end
