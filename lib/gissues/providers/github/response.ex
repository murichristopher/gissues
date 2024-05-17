defmodule Gissues.Providers.Github.Response do
  def parse(issues) do
    Enum.map(issues, &format_issue/1)
  end

  defp format_issue(issue) do
    %{
      author: get_in(issue, ~w[user login]),
      number: get_in(issue, ~w[number]),
      created_at: get_in(issue, ~w[created_at]),
      state: get_in(issue, ~w[state]),
      title: get_in(issue, ~w[title]),
      url: get_in(issue, ~w[url])
    }
  end
end
