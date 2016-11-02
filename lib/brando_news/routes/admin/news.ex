defmodule Brando.News.Routes.Admin do
  @moduledoc """
  Routes for Brando.News

  ## Usage:

  In `router.ex`

      scope "/admin", as: :admin do
        pipe_through :admin
        post_routes "/news", schema: Brando.Post

  """
  alias Brando.Admin.PostController
  alias Brando.Post
  import Brando.Villain.Routes.Admin

  @doc """
  Defines "RESTful" endpoints for the news resource.
  """
  defmacro post_routes(path), do:
    add_post_routes(path, PostController, [])

  defp add_post_routes(path, controller, opts) do
    map = Map.put(%{}, :schema, Keyword.get(opts, :schema, Post))
    options = Keyword.put([], :private, Macro.escape(map))
    quote do
      path         = unquote(path)
      ctrl         = unquote(controller)
      gallery_ctrl = Brando.Admin.GalleryController
      opts         = unquote(options)

      nil_opts     = Keyword.put(opts, :as, nil)

      villain_routes path, ctrl

      get    "#{path}",                                ctrl,         :index,          opts
      get    "#{path}/new",                            ctrl,         :new,            opts
      get    "#{path}/rerender",                       ctrl,         :rerender,       opts
      get    "#{path}/:id",                            ctrl,         :show,           opts
      get    "#{path}/:id/edit",                       ctrl,         :edit,           opts
      get    "#{path}/:id/delete",                     ctrl,         :delete_confirm, opts
      post   "#{path}",                                ctrl,         :create,         opts
      delete "#{path}/:id",                            ctrl,         :delete,         opts
      patch  "#{path}/:id",                            ctrl,         :update,         opts
      put    "#{path}/:id",                            ctrl,         :update,         nil_opts
      get    "#{path}/gallery/:id",                    gallery_ctrl, :show,           opts
      get    "#{path}/gallery/:id/new",                gallery_ctrl, :new,            opts
      post   "#{path}/gallery/:id/new/create-gallery", gallery_ctrl, :create,         opts
      get    "#{path}/gallery/:id/delete",             gallery_ctrl, :delete_confirm, opts
      delete "#{path}/gallery/:id",                    gallery_ctrl, :delete,         opts
    end
  end
end
