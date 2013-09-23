module PadsHelper
  def pads_cache_key(group)
    g = group.group_id
    s = sort_column
    d = sort_direction
    "#{g}-#{group.updated_at}-#{s}-#{d}"
  end

  def fetch_ep_last_edited(pad)
    _pad = Pad.find(pad.id)
    _pad.edited_at = DateTime.strptime(pad.ep_pad.last_edited.to_s, '%Q')
    _pad.save
  end
end
