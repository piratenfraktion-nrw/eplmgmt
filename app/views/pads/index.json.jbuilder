json.array!(@pads) do |pad|
  json.extract! pad, :pad_id, :group_id, :name, :password, :creator_id
  json.url pad_url(pad, format: :json)
end
