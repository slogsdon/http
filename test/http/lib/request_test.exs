defmodule Http.Lib.RequestTest do
  use ExUnit.Case, async: true
  alias Http.Lib.Request

  test "parse/1" do
    expected = %Http.Message{
      method: "GET",
      request_target: "/",
      http_version: "HTTP/1.1",
      headers: [{"Host", "example.com"}],
      body: ""
    }
    calculated = Request.parse(good_start_line <> "Host: example.com\r\n\r\n")

    assert calculated == expected
  end

  test "parse_start_line/1" do
    expected = {"GET", "/", "HTTP/1.1", ""}
    calculated = Request.parse_start_line(good_start_line)

    assert calculated == expected
  end

  test "parse_method/2" do
    expected = {"GET", "/ HTTP/1.1\r\n"}
    calculated = Request.parse_method(good_start_line)

    assert calculated == expected
  end

  test "parse_method/2 with CRLF chars" do
    expected = :error
    calculated = Request.parse_method("\r\n")

    assert calculated == expected
  end

  test "parse_method/2 with bad CRLF" do
    expected = :error
    calculated = Request.parse_method("\r \n")

    assert calculated == expected
  end

  test "parse_target/2" do
    expected = {"/", "HTTP/1.1\r\n"}
    calculated = Request.parse_target("/ HTTP/1.1\r\n")

    assert calculated == expected
  end

  test "parse_target/2 with CRLF chars" do
    expected = :error
    calculated = Request.parse_target("\r\n")

    assert calculated == expected
  end

  test "parse_target/2 with bad CRLF" do
    expected = :error
    calculated = Request.parse_target("\r \n")

    assert calculated == expected
  end

  test "parse_version/2" do
    expected = {"HTTP/1.1", ""}
    calculated = Request.parse_version("HTTP/1.1\r\n")

    assert calculated == expected
  end

  test "parse_version/2 with CRLF chars" do
    expected = :error
    calculated = Request.parse_version("\r\n")

    assert calculated == expected
  end

  test "parse_version/2 with bad CRLF" do
    expected = :error
    calculated = Request.parse_version("\r \n")

    assert calculated == expected
  end

  defp good_start_line, do: "GET / HTTP/1.1\r\n"
end
