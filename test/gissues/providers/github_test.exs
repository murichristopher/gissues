defmodule Github.Providers.GissuesTest do
  use ExUnit.Case, async: true
  import Mox
  import ExUnit.CaptureLog

  alias Gissues.Providers.Github

  setup :verify_on_exit!

  describe "fetch/2" do
    test "returns the response in the expected format" do
      Gissues.Http.AdapterMock
      |> expect(:get, fn
        "https://api.github.com/repos/john/todoapp/issues",
        [{"User-agent", "Elixir dave@pragprog.com"}] ->
          {:ok,
           %{
             status_code: 200,
             body: [
               %{
                 "user" => %{
                   "login" => "john"
                 },
                 "number" => 1,
                 "created_at" => "2020-09-10T12:40:16Z",
                 "state" => "open",
                 "title" => "Middleware to redirect in 500 errors",
                 "url" => "github.com/john/todoapp/issues/1"
               },
               %{
                 "user" => %{
                   "login" => "john"
                 },
                 "number" => 2,
                 "created_at" => "2021-09-10T12:40:16Z",
                 "state" => "closed",
                 "title" => "Remove unused routes",
                 "url" => "github.com/john/todoapp/issues/2"
               }
             ]
           }}
      end)

      assert Github.fetch("john", "todoapp") ==
               {:ok,
                [
                  %{
                    state: "open",
                    title: "Middleware to redirect in 500 errors",
                    number: 1,
                    author: "john",
                    url: "github.com/john/todoapp/issues/1",
                    created_at: "2020-09-10T12:40:16Z"
                  },
                  %{
                    state: "closed",
                    title: "Remove unused routes",
                    number: 2,
                    author: "john",
                    url: "github.com/john/todoapp/issues/2",
                    created_at: "2021-09-10T12:40:16Z"
                  }
                ]}
    end

    test "when the response is empty" do
      Gissues.Http.AdapterMock
      |> expect(:get, fn
        "https://api.github.com/repos/john/todoapp/issues",
        [{"User-agent", "Elixir dave@pragprog.com"}] ->
          {:ok, %{status_code: 200, body: []}}
      end)

      assert Github.fetch("john", "todoapp") == {:ok, []}
    end

    test "when an error occurs" do
      Gissues.Http.AdapterMock
      |> expect(:get, fn
        "https://api.github.com/repos/john/todoapp/issues",
        [{"User-agent", "Elixir dave@pragprog.com"}] ->
          :error
      end)

      assert Github.fetch("john", "todoapp") == :error
    end
  end
end
