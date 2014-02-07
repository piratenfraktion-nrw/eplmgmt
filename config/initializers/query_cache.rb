# Add logging to detect errors masked by lack-of-database-connection error in `restore_query_cache_settings`
class ::ActiveRecord::QueryCache
  def call(env)
    enabled       = ActiveRecord::Base.connection.query_cache_enabled
    connection_id = ActiveRecord::Base.connection_id
    ActiveRecord::Base.connection.enable_query_cache!

    response = @app.call(env)
    response[2] = Rack::BodyProxy.new(response[2]) do
      restore_query_cache_settings(connection_id, enabled)
    end

    response
  rescue Exception => e
    #### v
    Rails.logger.fatal("Caught exception in QueryCache:\n#{e.class} (#{e.message}):\n  #{e.backtrace.join("\n  ")}\n\n")
    #### ^
    restore_query_cache_settings(connection_id, enabled)
    raise e
  end
end
