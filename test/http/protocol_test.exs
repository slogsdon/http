defmodule Http.ProtocolTest do
  use ExUnit.Case, async: true
  alias Pool.Acceptor
  alias Pool.Transport.Tcp
  alias Http.Protocol

  @tcp_opts [:binary, {:active, false}]

  # TODO: Get a better way to test this module
  #       other than using Pool directly

  test "start_link/4" do
    calculated = Protocol.start_link(:test_0, nil, Tcp, [])

    assert calculated |> elem(0) == :ok
    assert calculated |> elem(1) |> is_pid
  end

  test "loop" do
    {:ok, listen} = :gen_tcp.listen(0, @tcp_opts)
    pid = Acceptor.start_link(listen, nil, Tcp, {Protocol, []}, ref: :test_1)
    {:ok, port} = :inet.port(listen)

    assert pid |> is_pid
    assert pid |> Process.alive?

    {:ok, socket} = :gen_tcp.connect({127,0,0,1}, port, @tcp_opts)
    sent = :gen_tcp.send(socket, "GET / HTTP/1.1\r\n\r\n")

    assert pid |> Process.alive?
    assert sent == :ok

    {:ok, data} = :gen_tcp.recv(socket, 0)

    assert data == "HTTP/1.1 200 OK\r\n\r\nGET / HTTP/1.1\r\n\r\n"
  end

  test "loop with timeout" do
    {:ok, listen} = :gen_tcp.listen(0, @tcp_opts)
    pid = Acceptor.start_link(listen, nil, Tcp, {Protocol, [receive_timeout: 100]}, ref: :test_2)
    {:ok, port} = :inet.port(listen)

    assert pid |> is_pid
    assert pid |> Process.alive?

    {:ok, socket} = :gen_tcp.connect({127,0,0,1}, port, @tcp_opts)

    assert pid |> Process.alive?

    received = :gen_tcp.recv(socket, 0)

    assert received |> elem(0) == :error
    assert received |> elem(1) == :closed
  end
end
