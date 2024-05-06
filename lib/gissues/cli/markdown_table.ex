defmodule Gissues.Cli.MarkdownTable do
  def generate_issues_table(issues) do
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

    Tabula.render_table(rows, [])
  end
end
