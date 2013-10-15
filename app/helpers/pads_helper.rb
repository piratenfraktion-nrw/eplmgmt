module PadsHelper
  def pads_cache_key(group)
    g = group.group_id
    s = sort_column
    d = sort_direction
    "#{g}-#{group.updated_at}-#{s}-#{d}"
  end
end
