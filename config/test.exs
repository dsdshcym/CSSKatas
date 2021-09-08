import Config

config :csskatas, CSSKatasWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  server: true

# In test we don't send emails.
config :csskatas, CSSKatas.Mailer,
  adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :wallaby,
  otp_app: :csskatas,
  screenshot_on_failure: true
