defmodule Http.Message do
  defstruct [
    # Request
    method: nil,
    request_target: nil,
    # Response
    status_code: nil,
    reason_phrase: nil,
    # Shared
    headers: [],
    http_version: nil,
    body: nil
  ]

  @type header :: {String.t, String.t}
  @type t :: %__MODULE__{
    method: String.t,
    request_target: String.t,
    status_code: 100..999,
    reason_phrase: String.t,
    headers: [header],
    http_version: String.t,
    body: String.t
  }
end
