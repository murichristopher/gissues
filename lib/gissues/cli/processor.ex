defmodule Gissues.Cli.Processor do
  def process(data, count) do
    data
    |> sort_issues()
    |> Enum.take(count)
  end

  defp sort_issues(issues), do: Enum.sort_by(issues, & &1.created_at, :desc)
end
