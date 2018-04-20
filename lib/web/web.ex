defmodule Brando.News.Web do
  def absinthe do
    repo = Brando.repo()
    quote do
      # Provides us with a DSL for defining GraphQL Types
      use Absinthe.Schema.Notation

      # Enable helpers for batching associated requests
      use Absinthe.Ecto, repo: unquote(repo)

      import Absinthe.Ecto
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
