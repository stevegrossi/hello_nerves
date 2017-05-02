# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

config :logger, level: :debug
config :hello_nerves, :led_pin, 26
config :hello_nerves, :input_pin, 16

config :hello_nerves, :wlan0,
  ssid: "Network Name",
  key_mgmt: :"WPA-PSK", # :NONE if no password
  psk: "password"

# Replace these with your Twitter API credentials
config :extwitter, :oauth, [
  consumer_key: "",
  consumer_secret: "",
  access_token: "",
  access_token_secret: ""
]

# Import target specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
# Uncomment to use target specific configurations

# import_config "#{Mix.Project.config[:target]}.exs"
