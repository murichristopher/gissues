defmodule TableFormatter do
  def print_table(issues) do
    headers = ["Number", "Title", "Author", "State", "Created At", "URL"]
    rows = Enum.map(issues, &format_issue_row/1)

    # Calculate max width for each column
    widths = Enum.reduce([headers | rows], Enum.map(headers, &String.length/1), &max_width/2)

    # Print header
    headers
    |> Enum.zip(widths)
    |> Enum.each(&print_column(&1, &2))

    IO.puts(Enum.map(widths, fn _ -> String.duplicate("=", 10) end) |> Enum.join(" "))

    # Print rows
    Enum.each(rows, fn row ->
      row
      |> Enum.zip(widths)
      |> Enum.each(&print_column(&1, &2))

      # New line for next row
      IO.puts("")
    end)
  end

  defp format_issue_row(issue) do
    [
      Integer.to_string(issue.number),
      issue.title,
      issue.author,
      issue.state,
      issue.created_at,
      issue.url
    ]
  end

  defp max_width(acc, values) do
    Enum.zip(acc, values)
    |> Enum.map(fn {a, v} -> max(a, String.length(v)) end)
  end

  defp print_column({value, width}, color \\ IO.ANSI.default()) do
    IO.write(IO.ANSI.format([color, String.pad_trailing(value, width), IO.ANSI.reset()]))
    # Padding between columns
    IO.write("  ")
  end
end
