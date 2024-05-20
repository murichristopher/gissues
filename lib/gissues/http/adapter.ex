defmodule Gissues.Http.Adapter do
  @callback get(url :: String.t(), headers :: list) :: {:ok, map()} | :error
end
