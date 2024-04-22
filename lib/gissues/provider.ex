defmodule Gissues.Provider do
  @callback fetch(user :: String.t(), project :: String.t()) :: {:ok, [map()]} | :error
end
