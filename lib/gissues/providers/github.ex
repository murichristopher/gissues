defmodule Gissues.Providers.Github do
  require Logger
  alias Gissues.Providers.Github.Response
  @behaviour Gissues.Provider
  @user_agent [{"User-agent", "Elixir dave@pragprog.com"}]
  @base_api_url Application.compile_env(:issues, :github_url)

  def fetch(user, project) do
    Logger.info("Fetching #{user}'s project #{project}")

    issues_url(user, project)
    |> make_request()
    |> parse_response()
  end

  def make_request(url) do
    {status_code, body} = request = HTTPoison.get(url, @user_agent)

    Logger.info("Got response: status code=#{status_code}")
    Logger.debug(fn -> inspect(body) end)

    request
  end

  defp issues_url(user, project), do: @base_api_url <> "repos/#{user}/#{project}/issues"

  defp parse_response({:ok, %{status_code: 200, body: body}}) do
    response =
      body
      |> Poison.Parser.parse!()
      |> Response.parse()

    {:ok, response}
  end

  defp parse_response({:ok, %{status_code: _}}), do: :error
end
