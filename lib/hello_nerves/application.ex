defmodule HelloNerves.Application do
  use Application
  require Logger

  @led_pin Application.get_env(:hello_nerves, :led_pin)

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    Logger.debug "Starting pin #{@led_pin} as output"
    {:ok, pin} = Gpio.start_link(@led_pin, :output)

    spawn fn -> blink_led_forever(pin) end

    {:ok, self()}
  end

  defp blink_led_forever(pin) do
    Logger.debug "Blink!"
    Gpio.write(pin, 1)
    :timer.sleep(500)
    Gpio.write(pin, 0)
    :timer.sleep(500)

    blink_led_forever(pin)
  end
end
