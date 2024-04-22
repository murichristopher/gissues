import Config
config :issues, github_url: "https://api.github.com/"

config :logger,
  compile: :compile_time_purge_matching
