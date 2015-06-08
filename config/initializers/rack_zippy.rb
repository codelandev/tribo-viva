if Rails.application.config.serve_static_files
  Rails.application.config.middleware.swap(ActionDispatch::Static, Rack::Zippy::AssetServer)
end
