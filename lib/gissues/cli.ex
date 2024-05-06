defmodule Gissues.CLI do
  alias Gissues.Cli.MarkdownTable
  alias Gissues.Cli.Processor
  @provider Gissues.Providers.Github

  @default_count 4

  def main(argv) do
    argv
    |> parse_args()
    |> process()
  end

  defp parse_args(argv) do
    argv
    |> OptionParser.parse(switches: [help: :boolean], aliases: [h: :help])
    |> elem(1)
    |> case do
      [user, project, count] -> {user, project, String.to_integer(count)}
      [user, project] -> {user, project, @default_count}
      _ -> :help
    end
  end

  defp process(:help) do
    IO.puts("""
    usage: issues <user> <project> [ count | #{@default_count} ]
    """)

    System.halt(0)
  end

  defp process({user, project, count}) do
    @provider.fetch(user, project)
    |> case do
      {:ok, response} ->
        response

      :error ->
        IO.puts("Error fetching issues")
        System.halt(2)
    end
    |> sort_issues()
    |> Enum.take(count)
    |> MarkdownTable.generate_issues_table()
    |> IO.puts()
  end

  defp sort_issues(issues), do: Enum.sort_by(issues, & &1.created_at, :desc)
end
