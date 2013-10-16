module PadsHelper
  def pads_cache_key
    (current_user.id.to_s rescue 'anon')
  end
end
