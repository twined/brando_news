defmodule Brando.Admin.GalleryController do
  @moduledoc """
  Controller for the Brando Gallery module.
  """
  use Brando.Web, :controller
  import Brando.News.Gettext
  import Brando.Utils.Schema, only: [put_creator: 2]
  import Brando.Plug.HTML
  alias Brando.{Gallery, Post, ImageSeries}

  plug :put_section, "gallery"
  plug :scrub_params, "gallery" when action in [:create, :update]

  @doc false
  def show(conn, %{"id" => id}) do
    gallery =
      Gallery
      |> Gallery.preload_creator
      |> Brando.repo.get_by!(id: id)
      |> Brando.repo.preload(imageseries: :images)

    conn
    |> assign(:page_title, gettext("Show gallery"))
    |> assign(:gallery, gallery)
    |> render(:show)
  end

  @doc false
  def new(conn, %{"id" => post_id}) do
    post       = Brando.repo.get_by!(Post, id: post_id)
    category   = Brando.repo.get_by!(Brando.ImageCategory, slug: "post-galleries")
    changeset  = ImageSeries.changeset(%ImageSeries{image_category_id: category.id}, :create)

    conn
    |> assign(:changeset, changeset)
    |> assign(:post, post)
    |> assign(:category_id, category.id)
    |> assign(:page_title, gettext("New gallery"))
    |> render(:new)
  end

  @doc false
  def create(conn, %{"id" => post_id, "gallery" => gallery}) do
    gallery = Map.put(gallery, "post_id", post_id)

    changeset =
      %Gallery{}
      |> put_creator(Brando.Utils.current_user(conn))
      |> Gallery.changeset(gallery)
      |> Brando.repo.insert

    conn
    |> render(:create, changeset: changeset)
  end

  @doc false
  def delete_confirm(conn, %{"id" => id}) do
    record =
      Brando.repo.get_by!(Gallery.preload_creator(Gallery), id: id)
      |> Brando.repo.preload(:post)
      |> Brando.repo.preload(:imageseries)

    conn
    |> assign(:page_title, gettext("Confirm deletion"))
    |> assign(:record, record)
    |> render(:delete_confirm)
  end

  @doc false
  def delete(conn, %{"id" => id}) do
    gallery = Brando.repo.get(Gallery, id)
    Brando.repo.delete!(gallery)

    conn
    |> put_flash(:notice, gettext("Gallery deleted"))
    |> redirect(to: router_module(conn).__helpers__.admin_post_path(conn, :index))
  end
end
