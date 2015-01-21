defmodule Http do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # worker(Http.Worker, [arg1, arg2, arg3])
    ]

    opts = [strategy: :one_for_one, name: Http.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def http(num_acceptors, options) do
    start_listener(:http,
                   num_acceptors,
                   :ranch_tcp,
                   options,
                   EchoProtocol,
                   [])
  end

  defp start_listener(name, num_acceptors, transport, t_opts, protocol, p_opts) do
    {:ok, _} = :ranch.start_listener(name,
                                     num_acceptors,
                                     transport,
                                     t_opts,
                                     protocol,
                                     p_opts)
  end
end
