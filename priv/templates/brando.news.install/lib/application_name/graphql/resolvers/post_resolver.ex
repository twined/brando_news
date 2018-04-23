defmodule <%= application_module %>.News.PostResolver do
  @moduledoc """
  Resolver for posts
  """
  alias <%= application_module %>.News

  @doc """
  Get all posts
  """
  def all(_, %{context: %{current_user: _current_user}}) do
    News.list_posts()
  end

  @doc """
  Find post by `post_id`
  """
  def find(%{post_id: post_id}, %{context: %{current_user: _current_user}}) do
    News.get_post(post_id)
  end

  @doc """
  Create new post from mutation
  """
  def create(%{post_params: params}, %{context: %{current_user: user}}) do
    News.create_post(params, user)
  end

  @doc """
  Update post from mutation
  """
  def update(%{post_id: post_id, post_params: params}, %{context: %{current_user: _user}}) do
    News.update_post(post_id, params)
  end
end
