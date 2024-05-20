defmodule GissuesTest do
  use ExUnit.Case
  import Mox

  describe "fetch_issues/3" do
    test "returns a list of issues of a given project" do
      Gissues.ProviderMock
      |> expect(:fetch, fn "john", "todo-app" ->
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
             created_at: "2023-11-05T16:23:02Z",
             title: "Define user's note creation section",
             number: 3,
             author: "murichristopher",
             state: "open",
             url: "https://api.github.com/repos/murichristopher/libellus/issues/3"
           }
         ]}
      end)

      user = "john"
      project = "todo-app"
      count = 2

      assert Gissues.fetch_issues(user, project, count) ==
               {:ok,
                [
                  %{
                    state: "open",
                    title: "Implement OAuth with Github",
                    number: 5,
                    author: "murichristopher",
                    url: "https://api.github.com/repos/murichristopher/libellus/issues/5",
                    created_at: "2023-11-05T21:48:35Z"
                  },
                  %{
                    state: "open",
                    title: "Define user's note creation section",
                    number: 3,
                    author: "murichristopher",
                    url: "https://api.github.com/repos/murichristopher/libellus/issues/3",
                    created_at: "2023-11-05T16:23:02Z"
                  }
                ]}
    end

    test "sorts the result in descending order" do
      Gissues.ProviderMock
      |> expect(:fetch, fn "john", "todo-app" ->
        {:ok,
         [
           %{
             created_at: "2022-11-05T21:48:35Z",
             title: "Implement OAuth with Github",
             number: 1,
             author: "murichristopher",
             state: "open",
             url: "https://api.github.com/repos/murichristopher/libellus/issues/5"
           },
           %{
             created_at: "2023-11-05T21:48:35Z",
             title: "Implement OAuth with Github",
             number: 2,
             author: "murichristopher",
             state: "open",
             url: "https://api.github.com/repos/murichristopher/libellus/issues/5"
           },
           %{
             created_at: "2024-11-05T16:23:02Z",
             title: "Solve layout problem in mobile",
             number: 3,
             author: "murichristopher",
             state: "open",
             url: "https://api.github.com/repos/murichristopher/libellus/issues/3"
           }
         ]}
      end)

      user = "john"
      project = "todo-app"
      count = 4

      assert {:ok,
              [
                %{
                  number: 3,
                  created_at: "2024-11-05T16:23:02Z",
                  title: _,
                  author: _,
                  state: _,
                  url: _
                },
                %{
                  number: 2,
                  created_at: "2023-11-05T21:48:35Z",
                  title: _,
                  author: _,
                  state: _,
                  url: _
                },
                %{
                  number: 1,
                  created_at: "2022-11-05T21:48:35Z",
                  title: _,
                  author: _,
                  state: _,
                  url: _
                }
              ]} = Gissues.fetch_issues(user, project, count)
    end

    test "takes a specific count of issues" do
      Gissues.ProviderMock
      |> expect(:fetch, fn "john", "todo-app" ->
        {:ok,
         [
           %{
             created_at: "2022-11-05T21:48:35Z",
             title: "Implement OAuth with Github",
             number: 1,
             author: "murichristopher",
             state: "open",
             url: "https://api.github.com/repos/murichristopher/libellus/issues/5"
           },
           %{
             created_at: "2023-11-05T21:48:35Z",
             title: "Implement OAuth with Github",
             number: 2,
             author: "murichristopher",
             state: "open",
             url: "https://api.github.com/repos/murichristopher/libellus/issues/5"
           },
           %{
             created_at: "2024-11-05T16:23:02Z",
             title: "Solve layout problem in mobile",
             number: 3,
             author: "murichristopher",
             state: "open",
             url: "https://api.github.com/repos/murichristopher/libellus/issues/3"
           }
         ]}
      end)

      user = "john"
      project = "todo-app"
      count = 1

      assert {:ok, issues} = Gissues.fetch_issues(user, project, count)

      assert [
               %{
                 number: 3,
                 created_at: "2024-11-05T16:23:02Z",
                 title: _,
                 author: _,
                 state: _,
                 url: _
               }
             ] = issues

      assert length(issues) == 1
    end

    test "returns :error when an error occours with the request" do
      Gissues.ProviderMock
      |> expect(:fetch, fn _, _ -> :error end)

      user = "john"
      project = "todo-app"
      count = 2

      assert Gissues.fetch_issues(user, project, count) == :error
    end
  end
end
