use Mix.Config

config :quantum, cron: [
  "* * * * *": {Worker, :run},
  "@reboot": {Worker, :once}
]

config :logger, :console,
  format: "$date $time $metadata [$level] $levelpad$message\n"