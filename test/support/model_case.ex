defmodule BrandoNews.SchemaCase do
  @moduledoc """
  This module defines the test case to be used by
  schema tests.

  You may define functions here to be used as helpers in
  your schema tests. See `errors_on/2`'s definition as reference.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      alias BrandoNews.Integration.TestRepo
      import Ecto.Schema
      import Ecto.Query, only: [from: 2]
      import BrandoNews.SchemaCase
    end
  end

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Brando.repo)
  end
end
