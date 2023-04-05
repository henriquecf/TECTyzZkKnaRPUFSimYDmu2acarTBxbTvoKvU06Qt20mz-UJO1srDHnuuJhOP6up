import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :askmybook, Askmybook.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "askmybook_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :askmybook, AskmybookWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "bJ4qUbqNzYGod5boudjr2+K5wfYiItcqa18hiLVYO3FJZErhS6624REm9X58/p2U",
  server: false

# In test we don't send emails.
config :askmybook, Askmybook.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
