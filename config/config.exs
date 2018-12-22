# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :b10g,
  ecto_repos: [B10g.Repo]

# Configures the endpoint
config :b10g, B10g.Endpoint,
  url: [host: "dev.curle.io"],
  secret_key_base: "7M0j/LbcRNECYWHIuCvGlc2agE3hkP8/Q8repBaETmVXvvjb0EJYpHfj6r+HKgHt",
  render_errors: [view: B10g.ErrorView, accepts: ~w(html json)],
  pubsub: [name: B10g.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]


# Configure aws
config :b10g, :aws,
  aws_bucket: "b10g",
  region: "eu-west-1",
  access_key_id: System.get_env("AWS_ACCESS_KEY_ID"),
  secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
