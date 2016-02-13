defmodule BrandoNews.RoutesTest do
  use ExUnit.Case

  setup do
    routes =
      Phoenix.Router.ConsoleFormatter.format(Brando.router)
    {:ok, [routes: routes]}
  end

  test "news_resources", %{routes: routes} do
    assert routes =~ "/admin/news/new"
    assert routes =~ "/admin/news/:id/edit"
  end
end