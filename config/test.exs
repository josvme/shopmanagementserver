use Mix.Config

# Configure your database
config :ms, Ms.Repo,
  username: "postgres",
  password: "postgres",
  database: "ms_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  port: 5433
# This setting can be used to debug tests. This sets the ecto timeout to 600 seconds.
# ownership_timeout: 600_000

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :ms, MsWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
