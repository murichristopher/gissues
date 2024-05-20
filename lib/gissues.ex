defmodule Gissues do
  def fetch_issues(user, project, count) do
    with {:ok, response} <- provider().fetch(user, project) do
      issues =
        response
        |> Enum.sort_by(& &1.created_at, :desc)
        |> Enum.take(count)

      {:ok, issues}
    end
  end

  defp provider(), do: Application.get_env(:gissues, :provider)
end
