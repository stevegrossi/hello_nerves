defmodule HelloNerves.Listener do
  require Logger

  @input_pin Application.get_env(:hello_nerves, :input_pin)

  def start_link do
    Logger.debug "Starting input on pin #{@input_pin}"
    {:ok, pid} = Gpio.start_link(@input_pin, :input)

    spawn fn -> listen_forever(pid) end

    {:ok, self()}
  end

  defp listen_forever(pid) do
    # Start listening for interrupts on rising and falling edges
    Gpio.set_int(pid, :both)
    loop()
  end

  defp loop do
    # Infinite loop receiving interrupts from gpio
    receive do
      {:gpio_interrupt, p, :rising} ->
        Logger.debug "Received rising event on pin #{p}"
        set_time()
        ExTwitter.update("I posted this tweet at @indyelixir by pressing a button on a Raspberry Pi! Thanks @NervesProject! #myelixirstatus")
      {:gpio_interrupt, p, :falling} ->
        Logger.debug "Received falling event on pin #{p}"
    end
    loop()
  end

  defp set_time do
    Logger.info "Setting system time"
    response = HTTPoison.get! "http://api.timezonedb.com/v2/get-time-zone?key=HJ7Z0CX8XZNY&format=json&by=zone&zone=America/Indiana/Indianapolis"
    json = Poison.decode!(response.body)
    dt_string = json["formatted"]
    Logger.debug "Setting date #{inspect(dt_string)}"
    System.cmd("date", ["-s", dt_string])
  end
end
