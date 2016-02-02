ExUnit.start

Mix.Task.run "ecto.create", ~w(-r WebHelloWorld.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r WebHelloWorld.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(WebHelloWorld.Repo)

