defmodule Brando.News.Mixin.Channels.AdminChannelMixin do
  defmacro __using__(mod \\ []) do
    quote(generated: true) do
      # delete post
      def handle_in("post:delete", %{"id" => id}, socket) do
        {:ok, _} = unquote(mod).delete_post(id)
        {:reply, {:ok, %{status: 200}}, socket}
      end

      # create new gallery
      def handle_in("gallery:create", params, socket) do
        {:ok, gallery} = unquote(mod).create_gallery(params)
        gallery = Map.merge(gallery, %{imageseries: %{id: gallery.imageseries_id}, creator: nil, post: nil})
        {:reply, {:ok, %{status: 200, gallery: gallery}}, socket}
      end

      # delete gallery
      def handle_in("gallery:delete", %{"id" => id}, socket) do
        unquote(mod).delete_gallery(id)
        {:reply, {:ok, %{status: 200}}, socket}
      end
    end
  end
end
