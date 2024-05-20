defmodule Gissues.CliTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureIO

  import Mox
  import Gissues.CLI, only: [main: 1]

  setup :verify_on_exit!

  describe "main/2" do
    test "output matches expected full table format" do
      Gissues.ProviderMock
      |> expect(:fetch, fn "murichristopher", "libellus" ->
        {:ok,
         [
           %{
             created_at: "2023-11-05T21:48:35Z",
             title: "Implement OAuth with Github",
             number: 5,
             author: "murichristopher",
             state: "open",
             url: "https://api.github.com/repos/murichristopher/libellus/issues/5"
           },
           %{
             created_at: "2023-11-05T17:13:44Z",
             title: "Middleware to redirect in 500 errors",
             number: 4,
             author: "murichristopher",
             state: "open",
             url: "https://api.github.com/repos/murichristopher/libellus/issues/4"
           },
           %{
             created_at: "2023-11-05T16:23:02Z",
             title: "Define user's note creation section",
             number: 3,
             author: "murichristopher",
             state: "open",
             url: "https://api.github.com/repos/murichristopher/libellus/issues/3"
           }
         ]}
      end)

      expected_output = """
      | Author          | Created At           | Number | State | Title                                | URL                                                            |
      |-----------------+----------------------+--------+-------+--------------------------------------+----------------------------------------------------------------|
      | murichristopher | 2023-11-05T21:48:35Z |      5 | open  | Implement OAuth with Github          | https://api.github.com/repos/murichristopher/libellus/issues/5 |
      | murichristopher | 2023-11-05T17:13:44Z |      4 | open  | Middleware to redirect in 500 errors | https://api.github.com/repos/murichristopher/libellus/issues/4 |
      | murichristopher | 2023-11-05T16:23:02Z |      3 | open  | Define user's note creation section  | https://api.github.com/repos/murichristopher/libellus/issues/3 |

      """

      args = ["murichristopher", "libellus"]

      assert capture_io(fn -> main(args) end) == expected_output
    end

    test "uses a default count of 4 when none is specified" do
      Gissues.ProviderMock
      |> expect(:fetch, fn "murichristopher", "libellus" ->
        {:ok,
         [
           %{
             created_at: "2023-11-05T21:48:35Z",
             title: "Implement OAuth with Github",
             number: 1,
             author: "murichristopher",
             state: "open",
             url: "https://api.github.com/repos/murichristopher/libellus/issues/5"
           },
           %{
             created_at: "2023-11-05T17:13:44Z",
             title: "Middleware to redirect in 500 errors",
             number: 2,
             author: "murichristopher",
             state: "open",
             url: "https://api.github.com/repos/murichristopher/libellus/issues/4"
           },
           %{
             created_at: "2023-11-05T16:23:02Z",
             title: "Define users's route",
             number: 3,
             author: "murichristopher",
             state: "open",
             url: "https://api.github.com/repos/murichristopher/libellus/issues/3"
           },
           %{
             created_at: "2023-11-05T16:23:02Z",
             title: "Add logout button",
             number: 4,
             author: "murichristopher",
             state: "open",
             url: "https://api.github.com/repos/murichristopher/libellus/issues/2"
           },
           %{
             created_at: "2023-11-05T16:23:02Z",
             title: "Remove deleted users",
             number: 5,
             author: "murichristopher",
             state: "open",
             url: "https://api.github.com/repos/murichristopher/libellus/issues/1"
           }
         ]}
      end)

      args = ["murichristopher", "libellus"]

      output = capture_io(fn -> main(args) end)

      assert String.contains?(output, "Add logout button")
      refute String.contains?(output, "Remove deleted users")
    end

    test "prints help when `-h` or `--help` flag is passed" do
      expected_output = "usage: issues <user> <project> [ count | 4 ]\n\n"

      assert capture_io(fn -> main(["-h"]) end) == expected_output
      assert capture_io(fn -> main(["--help"]) end) == expected_output
    end

    test "displays error message when fetch fails" do
      Gissues.ProviderMock
      |> expect(:fetch, fn _, _ -> :error end)

      args = ["username", "repo"]

      assert capture_io(fn -> main(args) end)
             |> String.contains?("Error fetching issues")
    end
  end
end
