defmodule HelloNerves.Blinker do
  require Logger

  @led_pin Application.get_env(:hello_nerves, :led_pin)

  def start_link do
    Logger.debug "Starting pin #{@led_pin} as output"
    {:ok, pin} = Gpio.start_link(@led_pin, :output)

    spawn_link fn -> blink_led_forever(pin) end

    {:ok, self()}
  end

  defp blink_led_forever(pin) do
    Logger.debug "Blinking pin #{@led_pin}"
    blink_ms = HelloNerves.Store.get(:blink_ms)
    Gpio.write(pin, 1)
    :timer.sleep(blink_ms)
    Gpio.write(pin, 0)
    :timer.sleep(blink_ms)

    blink_led_forever(pin)
  end
end
