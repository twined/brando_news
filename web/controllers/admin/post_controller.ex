defmodule Brando.Admin.PostController do
  @moduledoc """
  Controller for the Brando News module.
  """

  use Brando.Web, :controller
  use Brando.Villain, [:controller, [
    image_model: Brando.Image,
    series_model: Brando.ImageSeries]]

  import Brando.News.Gettext
  import Brando.Utils, only: [helpers: 1]
  import Brando.Utils.Model, only: [put_creator: 2]
  import Brando.Plug.HTML
  import Brando.Plug.Uploads

  alias Brando.Post

  plug :put_section, "news"
  plug :check_for_uploads,
     {"post", Brando.Post} when action in [:create, :update]
  plug :scrub_params, "post" when action in [:create, :update]

  @doc false
  def index(conn, _params) do
    posts =
      Post
      |> Post.order
      |> Post.preload_creator
      |> Brando.repo.all

    conn
    |> assign(:page_title, gettext("Index - posts"))
    |> assign(:posts, posts)
    |> render(:index)
  end

  @doc false
  def rerender(conn, _params) do
    posts = Brando.repo.all(Post)

    for post <- posts do
      Post.rerender_html(Post.changeset(post, :update, %{}))
    end

    conn
    |> put_flash(:notice, gettext("Posts re-rendered"))
    |> redirect(to: helpers(conn).admin_post_path(conn, :index))
  end

  @doc false
  def show(conn, %{"id" => id}) do
    post =
      Post
      |> Post.preload_creator
      |> Brando.repo.get_by!(id: id)

    conn
    |> assign(:page_title, gettext("Show post"))
    |> assign(:post, post)
    |> render(:show)
  end

  @doc false
  def new(conn, _params) do
    changeset = Post.changeset(%Post{}, :create)

    conn
    |> assign(:changeset, changeset)
    |> assign(:page_title, gettext("New post"))
    |> render(:new)
  end

  @doc false
  def create(conn, %{"post" => post}) do
    changeset =
      %Post{}
      |> put_creator(Brando.Utils.current_user(conn))
      |> Post.changeset(:create, post)

    case Brando.repo.insert(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:notice, gettext("Post created"))
        |> redirect(to: router_module(conn).__helpers__.admin_post_path(conn, :index))
      {:error, changeset} ->
        conn
        |> assign(:page_title, gettext("New post"))
        |> assign(:post, post)
        |> assign(:changeset, changeset)
        |> put_flash(:error, gettext("Errors in form"))
        |> render(:new)
    end
  end

  @doc false
  def edit(conn, %{"id" => id}) do
    changeset =
      Post
      |> Brando.repo.get!(id)
      |> Post.encode_data
      |> Post.changeset(:update)

    conn
    |> assign(:page_title, gettext("Edit post"))
    |> assign(:changeset, changeset)
    |> assign(:id, id)
    |> render(:edit)
  end

  @doc false
  def update(conn, %{"post" => post, "id" => id}) do
    changeset =
      Post
      |> Brando.repo.get_by!(id: id)
      |> Post.changeset(:update, post)

    case Brando.repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:notice, gettext("Post updated"))
        |> redirect(to: router_module(conn).__helpers__.admin_post_path(conn, :index))

      {:error, changeset} ->
        conn
        |> assign(:id, id)
        |> assign(:post, post)
        |> assign(:changeset, changeset)
        |> assign(:page_title, gettext("Edit post"))
        |> put_flash(:error, gettext("Errors in form"))
        |> render(:edit)
    end
  end

  @doc false
  def delete_confirm(conn, %{"id" => id}) do
    record = Brando.repo.get_by!(Post.preload_creator(Post), id: id)

    conn
    |> assign(:page_title, gettext("Confirm deletion"))
    |> assign(:record, record)
    |> render(:delete_confirm)
  end

  @doc false
  def delete(conn, %{"id" => id}) do
    post = Brando.repo.get(Post, id)

    {:ok, post} = Brando.Images.Utils.delete_original_and_sized_images(post, :cover)
    Brando.repo.delete!(post)

    conn
    |> put_flash(:notice, gettext("Post deleted"))
    |> redirect(to: router_module(conn).__helpers__.admin_post_path(conn, :index))
  end
end
