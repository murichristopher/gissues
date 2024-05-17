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

  defp extract_project_params(arg) do
    case arg do
      [user, project, count] -> {user, project, String.to_integer(count)}
      [user, project] -> {user, project, @default_issues_count}
      _ -> :help
    end
  end

  defp process(:help) do
    IO.puts("""
    usage: issues <user> <project> [ count | #{@default_issues_count} ]
    """)
  end

  defp process({user, project, count}) do
    with {:ok, response} <- provider().fetch(user, project) do
      response
      |> Enum.sort_by(& &1.created_at, :desc)
      |> Enum.take(count)
      |> MarkdownTable.generate_issues_table()
      |> IO.puts()
    else
      _ -> IO.puts("Error fetching issues")
    end
  end

  defp provider() do
    Application.get_env(:gissues, :provider)
  end
end
