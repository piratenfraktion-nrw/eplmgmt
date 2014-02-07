# If we have an error while trying to checkout a connection, we really ought
# to clean it up. Otherwise, we don't ever recover the connection and the
# connection pool gets exhausted. ConnectionTimeoutErrors are the one
# exception to this --- they occur when the connection pool is already
# exhausted, meaning that a connectionw as never checked out.
class ::ActiveRecord::ConnectionAdapters::ConnectionPool
  def checkout
    synchronize do
      #### v
      begin
        #### ^
        conn = acquire_connection
        conn.lease
        checkout_and_verify(conn)
        #### v
      rescue
        unless conn.nil?
          Rails.logger.fatal("Error after checking out a connection --- cleaning it up to avoid exhausting the connection pool.")
          remove conn
          conn.disconnect!
        end
        raise
      end
      #### ^
    end
  end
end
