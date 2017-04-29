defmodule HelloNerves.Router do
  use Plug.Router

  plug Plug.Logger
  plug :match
  plug :dispatch

  get "/" do
    send_resp(conn, 200, "Hello from Nerves!")
  end

  match _ do
    send_resp(conn, 404, "Oops!")
  end
end
