defmodule Brando.News do
  alias Brando.News.Post
  alias Brando.Gallery

  alias Brando.Images

  import Ecto.Query
  import Brando.Utils.Schema, only: [put_creator: 2]

  def get_post_by(slug: slug) do
    images_query = from i in Brando.Image, order_by: i.sequence

    post = Brando.repo.one(
      from p in Post,
        where: p.slug == ^slug and
               p.status == ^:published,
        preload: [gallery: [imageseries: [images: ^images_query]]]
    )

    case post do
      nil -> {:error, {:post, :not_found}}
      _ -> {:ok, post}
    end
  end

  def get_post(id) do
    post =
      Post
      |> where(id: ^id)
      |> preload([:gallery, :creator, :project])
      |> Brando.repo.one

    case post do
      nil -> {:error, {:post, :not_found}}
      _ -> {:ok, post}
    end
  end

  def all(filter \\ nil) do
    query = order_by(Post, [p], desc: p.publish_at)
    query = filter && where(query, [p], p.status == ^filter) || query

    posts = Brando.repo.all(query)

    {:ok, posts}
  end

  def list_posts_paginated(params) do
    query =
      from p in Post,
        where: p.status == ^:published,
        order_by: [desc: p.publish_at]

    page = Brando.repo.paginate(query, params)

    {:ok, page}
  end

  def list_posts(filter \\ nil, limit \\ nil) do
    query = order_by(Post, [p], desc: p.publish_at)
    query = filter && where(query, [p], p.status == ^filter) || query
    query = limit && limit(query, ^limit) || query

    posts = Brando.repo.all(query)

    {:ok, posts}
  end

  def create_post(params, user) do
    %Post{}
    |> put_creator(user)
    |> Post.changeset(:create, params)
    |> Brando.repo.insert
  end

  def update_post(post_id, params) do
    {:ok, post} = get_post(post_id)
    post
    |> Post.changeset(:update, params)
    |> Brando.repo.update
  end

  def delete_post(id) do
    {:ok, post} = get_post(id)
    Images.Utils.delete_original_and_sized_images(post, :cover)

    if post.gallery && post.gallery.imageseries_id do
      Images.delete_series(post.gallery.imageseries_id)
    end

    Brando.repo.delete!(post)

    {:ok, post}
  end

  def create_gallery(params) do
    %Gallery{}
    |> Gallery.changeset(params)
    |> Brando.repo.insert
  end

  def delete_gallery(id) do
    gallery = Brando.repo.get(Gallery, id)
    Brando.repo.delete(gallery)
  end
end
