defmodule Brando.Admin.GalleryView do
  @moduledoc """
  View for the Brando gallery module.
  """
  use Brando.Web, :view
  import Brando.News.Gettext

  def render("create.json", %{conn: conn, changeset: changeset}) do
    case changeset do
      {:ok, record}    ->
        %{
          status: "200",
          href: Brando.helpers.admin_image_series_path(conn, :upload, record.imageseries_id)
        }
      {:error, _} ->
        %{status: "400"}
    end
  end
end
