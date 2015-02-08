defmodule HttpTest do
  use ExUnit.Case

  test "http/1" do
    calculated = Http.http

    assert calculated |> elem(0) == :ok
    assert calculated |> elem(1) |> is_pid

    calculated |> elem(1) |> Process.exit(:normal)
  end

  test "https/1" do
    calculated = Http.https

    assert calculated |> elem(0) == :error
  end
end
