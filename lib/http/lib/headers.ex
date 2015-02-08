defmodule Http.Lib.Headers do
  @crlf [?\r, ?\n]
  # OWS, RWS, BWS
  @ws [?\t, ?\s]
  @delimiters [?", ?(, ?), ?,, ?/, ?:, ?;,
               ?<, ?=, ?>, ??, ?@, ?[, ?\\,
               ?], ?{, ?}]
  @obs_text Enum.to_list(128..255)
  @qdtext @obs_text
       ++ @ws
       ++ [?!]
       ++ Enum.to_list(35..91)
  @ctext @obs_text
      ++ @ws
      ++ Enum.to_list(33..39)
      ++ Enum.to_list(42..91)
      ++ Enum.to_list(93..126)
  # visible USASCII characters
  @vchar Enum.to_list(33..126)

  def parse_from_binary(buffer, headers \\ [], current \\ <<>>, cr \\ false)
  def parse_from_binary(<<char :: size(8), rest :: binary>>, headers, current, cr) do
    case char do
      ?\r when not cr ->
        parse_from_binary(rest, headers, current, true)
      ?\n when cr ->
        {headers, rest}
      # possible OWS from previous value's obs-fold
      c when c in @ws
         and current == <<>>
         and not cr ->
        parse_from_binary(rest, headers)
      # disallow whitespace
      c when c in @ws
         and not cr ->
        :error
      ?: when not cr ->
        case parse_value_from_binary(rest) do
          {value, rest} ->
            headers = [{current, value}|headers]
            parse_from_binary(rest, headers)
          :error ->
            :error
        end
      _ when not cr ->
        parse_from_binary(rest, headers, current <> <<char>>)
    end
  end

  def parse_value_from_binary(buffer, value \\ <<>>, cr \\ false)
  def parse_value_from_binary(<<char :: size(8), rest :: binary>>, value, cr) do
    case char do
      # OWS
      c when c in @ws
         and value == <<>>
         and not cr ->
        parse_value_from_binary(rest, value)
      c when (c in @vchar
          or c in @obs_text
          or c in @ws)
         and not cr ->
        parse_value_from_binary(rest, value <> <<c>>)
      ?\n when cr ->
        {value, rest}
      ?\r when not cr ->
        parse_value_from_binary(rest, value, true)
      _ ->
        :error
    end
  end
end
