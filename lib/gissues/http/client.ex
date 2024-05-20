defmodule Gissues.Http.Client do
  @behaviour Gissues.Http.Adapter

  def get(url, headers) do
    case HTTPoison.get(url, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        parsed_body = Poison.Parser.parse!(body)
        {:ok, %{status_code: 200, body: parsed_body}}

      _ ->
        :error
    end
  end
end
