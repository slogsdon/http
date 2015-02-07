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

  def http(options \\ []) do
    start_child(:http, options)
  end

  def https(options \\ []) do
    start_child(:https, options)
  end

  def start_child(ref, options) do
    spec = child_spec(ref, options)
    case Supervisor.start_child(Http.Supervisor, spec) do
      {:ok, pid} ->
        {:ok, pid}
      otherwise ->
        otherwise
    end
  end

  @doc """
  Creates a proper child worker spec to be
  inserted into the supervision tree.
  """
  @spec child_spec(atom, any) :: any
  def child_spec(ref, options) do
    transport = case ref do
                  :http -> Pool.Transport.Tcp
                  :https -> Pool.Transport.SSL
                end

    num_acceptors = options[:num_acceptors] || 10
    opts = options
            |> Keyword.update(:port, 4000, &(&1))
            |> Keyword.delete(:num_acceptors)

    lopts = [
      ref,
      num_acceptors,
      transport,
      opts,
      Http.Protocol,
      []
    ]

    {ref, {Pool, :start_listener, lopts},
          :permanent, 5000, :worker, [ref]}
  end
end
