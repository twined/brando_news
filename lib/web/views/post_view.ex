defmodule Brando.Admin.PostView do
  @moduledoc """
  View for the Brando News module.
  """
  use Brando.Web, :view
  alias Brando.PostForm
  import Brando.News.Gettext

  def attached_gallery(post) do
    if enabled_galleries?() do
      galleries = Brando.repo.all(Brando.Gallery)
      case get_gallery_for(galleries, post) do
        nil     ->
          href = Brando.helpers.admin_gallery_path(Brando.endpoint, :new, post.id)
          ~s(<a href="#{href}"><i class="icon-centered fa fa-plus"></i></a>)
        gallery ->
          href = Brando.helpers.admin_gallery_path(Brando.endpoint, :show, gallery.id)
          ~s(<a href="#{href}"><i class="icon-centered fa fa-image"></i></a>)
      end
    end
  end

  defp get_gallery_for([], _) do
    nil
  end
  defp get_gallery_for(galleries, post) do
    Enum.find(galleries, nil, &(&1.post_id == post.id))
  end

  def enabled_galleries? do
    news_config() && Keyword.get(news_config(), :enable_galleries, false) || false
  end

  defp news_config() do
    Brando.config(Brando.News)
  end
end
