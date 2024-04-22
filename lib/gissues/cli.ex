defmodule Gissues.CLI do
  @provider Gissues.Providers.Github

  @default_count 4

  def main(argv) do
    argv
    |> parse_args()
    |> process()
  end

  def process(:help) do
    IO.puts("""
    usage: issues <user> <project> [ count | #{@default_count} ]
    """)

    System.halt(0)
  end

  def process({user, project, count}) do
    @provider.fetch(user, project)
    |> decode_response()
    |> sort_issues()
    |> first(count)
    |> print_issues_table()
  end

  def first(issues, count) do
    Enum.take(issues, count)
  end

  defp print_issues_table(issues) do
    rows =
      Enum.map(issues, fn issue ->
        %{
          "Number" => issue.number,
          "Title" => issue.title,
          "Author" => issue.author,
          "State" => issue.state,
          "Created At" => issue.created_at,
          "URL" => issue.url
        }
      end)

    Tabula.print_table(rows, [])
  end

  defp sort_issues(issues), do: Enum.sort_by(issues, & &1.created_at, :desc)

  def decode_response({:ok, response}) do
    response
  end

  def decode_response(:error) do
    IO.puts("Error fetching issues")
    System.halt(2)
  end

  def parse_args(argv) do
    argv
    |> OptionParser.parse(switches: [help: :boolean], aliases: [h: :help])
    |> elem(1)
    |> filtered_args()
  end

  defp filtered_args([user, project, count]),
    do: {user, project, String.to_integer(count)}

  defp filtered_args([user, project]), do: {user, project, @default_count}

  defp filtered_args(_), do: :help
end
