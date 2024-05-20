import Config
config :gissues, github_url: "https://api.github.com/"

config :gissues, provider: Gissues.Providers.Github

config :logger,
  compile: :compile_time_purge_matching

config :gissues, :http_adapter, Gissues.Http.Client
