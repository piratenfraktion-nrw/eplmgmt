json.array!(@group_users) do |group_user|
  json.extract! group_user, :group_id, :user_id, :manager
  json.url group_user_url(group_user, format: :json)
end
