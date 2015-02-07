defmodule Http.Protocol do
  @behaviour Pool.Protocol

  def start_link(ref, socket, transport, opts) do
    pid = spawn_link(__MODULE__, :init, [ref, socket, transport, opts])
    {:ok, pid}
  end

  def init(_ref, socket, transport, opts \\ []) do
    loop(socket, transport, opts)
  end

  defp loop(socket, transport, opts \\ []) do
    receive_timeout = opts[:receive_timeout] || 5_000
    case transport.receive(socket, 0, receive_timeout) do
      {:ok, data} ->
        IO.inspect data
        loop(socket, transport)
      _ ->
        :ok = transport.close(socket)
    end
  end
end
