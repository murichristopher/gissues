defmodule Gissues.Providers.Github do
  require Logger
  alias Gissues.Providers.Github.Formatter
  @behaviour Gissues.Provider
  @user_agent [{"User-agent", "Elixir dave@pragprog.com"}]
  @base_api_url Application.compile_env(:gissues, :github_url)

  def fetch(user, project) do
    Logger.info("Fetching #{user}'s project #{project}")

    issues_url(user, project)
    |> make_request()
    |> parse_response()
  end

  defp issues_url(user, project), do: @base_api_url <> "repos/#{user}/#{project}/issues"

  defp make_request(url), do: http_client().get(url, @user_agent)

  defp parse_response({:ok, %{status_code: 200, body: body}}) do
    response = Formatter.format_issues(body)

    {:ok, response}
  end

  defp parse_response(_), do: :error

  defp http_client(), do: Application.get_env(:gissues, :http_adapter)
end
