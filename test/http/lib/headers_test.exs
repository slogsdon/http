defmodule Http.Lib.HeadersTest do
  use ExUnit.Case, async: true
  alias Http.Lib.Headers

  test "parse_from_binary/4" do
    expected = {[{"Host", "example.com"}], ""}
    calculated = Headers.parse_from_binary("Host: example.com\r\n\r\n")

    assert calculated == expected
  end

  test "parse_from_binary/4 with OWS before field-name" do
    expected = {[{"Host", "example.com"}], ""}
    calculated = Headers.parse_from_binary(" \tHost: example.com\r\n\r\n")

    assert calculated == expected
  end

  test "parse_from_binary/4 with OWS after field-name" do
    expected = :error
    calculated = Headers.parse_from_binary("Host \t: example.com\r\n\r\n")

    assert calculated == expected
  end

  test "parse_from_binary/4 with OWS before field-value" do
    expected = {[{"Host", "example.com"}], ""}
    calculated = Headers.parse_from_binary("Host:  \texample.com\r\n\r\n")

    assert calculated == expected
  end

  test "parse_from_binary/4 with OWS after field-value" do
    expected = {[{"Host", "example.com \t"}], ""}
    calculated = Headers.parse_from_binary("Host: example.com \t\r\n\r\n")

    assert calculated == expected
  end

  test "parse_from_binary/4 with obs-fold" do
    expected = {[{"Host", "example.com"}], ""}
    calculated = Headers.parse_from_binary("Host: example.com\r\n \t\r\n")

    assert calculated == expected
  end
end
