defmodule Brando.News do
  @moduledoc """
  Domain for Brando.News
  """
  import Ecto.Query
  alias Brando.News.Post

  def list_posts() do
    Brando.repo.all(
      from p in Post,
        where: p.status == ^:published,
        order_by: [desc: p.featured, desc: p.publish_at]
    )
  end

  def get_post_by(opts) do
    post = Brando.repo.get_by(Post, opts)

    case post do
      nil  -> {:error, {:post, :not_found}}
      post -> {:ok, post}
    end
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
