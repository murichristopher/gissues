defmodule Gissues.Providers.Github.FormatterTest do
  use ExUnit.Case
  alias Gissues.Providers.Github.Formatter

  describe "format_issues/2" do
    test "parses a list of issues to a desired format" do
      issues = [
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

      assert Formatter.format_issues(issues) == [
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
             ]
    end

    test "handles empty issues" do
      issues = []

      assert Formatter.format_issues(issues) == []
    end

    test "handles invalid inpuut" do
      issues = [
        %{
          "user" => %{
            "login" => "john"
          }
        }
      ]

      assert Formatter.format_issues(issues) == [
               %{state: nil, title: nil, number: nil, author: "john", url: nil, created_at: nil}
             ]
    end
  end
end
