ExUnit.start()

Mox.defmock(Gissues.ProviderMock, for: Gissues.Provider)
Application.put_env(:gissues, :provider, Gissues.ProviderMock)

Mox.defmock(Gissues.Http.AdapterMock, for: Gissues.Http.Adapter)
Application.put_env(:gissues, :http_adapter, Gissues.Http.AdapterMock)

Application.put_env(:gissues, :github_url, "https://api.test.github.com/")
