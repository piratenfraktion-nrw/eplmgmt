# adding logging of a backtrace to abstractadapter, because we are getting the
# error logged, but not the full backtrace.
class ::ActiveRecord::ConnectionAdapters::AbstractAdapter
  protected

  def log(sql, name = "SQL", binds = [])
    @instrumenter.instrument(
      "sql.active_record",
      :sql           => sql,
      :name          => name,
      :connection_id => object_id,
      :binds         => binds) { yield }
  rescue => e
    message = "#{e.class.name}: #{e.message}: #{sql}"
    @logger.error message if @logger
    #### v
    @logger.error "extra logging: #{e.class.name}: #{e.message}: #{sql}:\n #{e.backtrace.join("\n  ")}" if @logger
    #### ^
    exception = translate_exception(e, message)
    exception.set_backtrace e.backtrace
    raise exception
  end
end
