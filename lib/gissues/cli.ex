defmodule Gissues.CLI do
  alias Gissues.Cli.MarkdownTable

  @default_count 4

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

  defp extract_project_params(arg) do
    arg
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
  end

  defp process({user, project, count}) do
    case provider().fetch(user, project) do
      {:ok, response} ->
        response
        |> sort_issues()
        |> Enum.take(count)
        |> MarkdownTable.generate_issues_table()
        |> IO.puts()

      :error ->
        IO.puts("Error fetching issues")

        :error
    end
  end

  defp sort_issues(issues), do: Enum.sort_by(issues, & &1.created_at, :desc)

  defp provider do
    Application.get_env(:gissues, :provider)
  end
end
