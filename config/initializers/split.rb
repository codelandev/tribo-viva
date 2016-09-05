username, password =
  Rails.application.secrets.to_h.slice(:split_username, :split_password).values

if username.present?
  Split::Dashboard.use Rack::Auth::Basic do |username, password|
    username == username && password == password
  end
end
