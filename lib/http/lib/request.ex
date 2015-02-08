defmodule Http.Lib.Request do
  @crlf [?\r, ?\n]

  def parse(buffer) do
    {method, target, version, rest} = parse_start_line(buffer)
    {headers, rest} = Http.Lib.Headers.parse_from_binary(rest)
    %Http.Message{
      method: method,
      request_target: target,
      http_version: version,
      headers: headers,
      body: rest
    }
  end

  # method SP request-target SP HTTP-version CRLF
  def parse_start_line(buffer) do
    {method, rest} = parse_method(buffer)
    {target, rest} = parse_target(rest)
    {version, rest} = parse_version(rest)
    {method, target, version, rest}
  end

  def parse_method(buffer, method \\ <<>>)
  def parse_method(<<char :: size(8), rest :: binary>>, method) do
    case char do
      c when c in @crlf -> :error
      ?\s -> {method, rest}
      _ -> parse_method(rest, method <> <<char>>)
    end
  end

  def parse_target(buffer, target \\ <<>>)
  def parse_target(<<char :: size(8), rest :: binary>>, target) do
    case char do
      c when c in @crlf -> :error
      ?\s -> {target, rest}
      _ -> parse_target(rest, target <> <<char>>)
    end
  end

  def parse_version(buffer, version \\ <<>>, cr \\ false)
  def parse_version(<<char :: size(8), rest :: binary>>, version, cr) do
    case char do
      ?\n when cr
           and version == <<>> ->
        :error
      ?\n when cr ->
        {version, rest}
      ?\r when not cr ->
        parse_version(rest, version, true)
      c when not cr ->
        parse_version(rest, version <> <<c>>)
      _ ->
        :error
    end
  end
end
