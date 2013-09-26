module PadsHelper
  def pads_cache_key(group)
    g = group.group_id
    s = sort_column
    d = sort_direction
    "#{g}-#{group.updated_at}-#{s}-#{d}"
  end

  def fetch_ep_last_edited(pad)
    begin
      _pad = Pad.find(pad.id)
      last_edit = DateTime.strptime(pad.ep_pad.last_edited.to_s, '%Q')
      if last_edit.to_time.to_i > _pad.edited_at.to_time.to_i
        _pad.edited_at = DateTime.now
        _pad.save
      end
    rescue
      logger.error "HIT THE FUCKING BUG"
    end
  end
end
