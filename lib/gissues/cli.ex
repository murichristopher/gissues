defmodule Gissues.CLI do
  alias Gissues.Cli.MarkdownTable
  @default_issues_count 4

  def main(argv) do
    argv
    |> parse_args()
    |> process()
  end

  defp parse_args(argv) do
    argv
    |> OptionParser.parse(switches: [help: :boolean], aliases: [h: :help])
    |> case do
      {[help: true], _, _} ->
        :help

      parsed_args ->
        parsed_args
        |> elem(1)
        |> extract_project_params()
    end
  end

  defp extract_project_params([user, project, count]),
    do: {user, project, String.to_integer(count)}

  defp extract_project_params([user, project]), do: {user, project, @default_issues_count}

  defp extract_project_params(_), do: :help

  defp process(:help) do
    IO.puts("""
    usage: issues <user> <project> [ count | #{@default_issues_count} ]
    """)
  end

  defp process({user, project, count}) do
    case Gissues.fetch_issues(user, project, count) do
      {:ok, issues} ->
        issues
        |> MarkdownTable.generate_issues_table()
        |> IO.puts()

      _ ->
        IO.puts("Error fetching issues")
    end
  end
end
