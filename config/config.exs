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
  url: [host: "localhost"],
  secret_key_base: "7M0j/LbcRNECYWHIuCvGlc2agE3hkP8/Q8repBaETmVXvvjb0EJYpHfj6r+HKgHt",
  render_errors: [view: B10g.ErrorView, accepts: ~w(html json)],
  pubsub: [name: B10g.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
