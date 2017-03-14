defmodule Brando.News do
  @moduledoc """
  Domain for Brando.News
  """
  import Ecto.Query
  alias Brando.News.Post

  def list_posts() do
    Brando.repo.all(
      from p in Post,
        order_by: p.publish_at
    )
  end

  @doc """
  Gets the configuration for `module` under :brando,
  as set in config.exs
  """
  def config(key) do
    case Application.get_env(:brando, Brando.News) do
      nil -> nil
      mod -> Keyword.get(mod, key, nil)
    end
  end
end
