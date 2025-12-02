# Configure secret_key_base from environment variable
Rails.application.config.secret_key_base = ENV['SECRET_KEY_BASE']
