defmodule Brando.News.PostResolver do
  @moduledoc """
  Resolver for posts
  """
  use Brando.News.Web, :resolver
  alias Brando.News

  @doc """
  Get all clients
  """
  def all(_, %{context: %{current_user: _current_user}}) do
    News.list_posts()
  end

  def find(%{post_id: post_id}, %{context: %{current_user: _current_user}}) do
    News.get_post(post_id)
  end

  def create(%{post_params: params}, %{context: %{current_user: user}}) do
    News.create_post(params, user)
  end

  def update(%{post_id: post_id, post_params: params}, %{context: %{current_user: _user}}) do
    News.update_post(post_id, params)
  end
end
