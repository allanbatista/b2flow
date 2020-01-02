
Sidekiq.configure_server do |config|
  config.redis = { url: AppConfig.B2FLOW__SIDEKIQ__REDIS_URL }
end

Sidekiq.configure_client do |config|
  config.redis = { url: AppConfig.B2FLOW__SIDEKIQ__REDIS_URL }
end