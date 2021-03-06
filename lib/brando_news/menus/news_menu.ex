defmodule Brando.News.Menu do
  @moduledoc """
  Menu definitions for the News Menu. See `Brando.Menu` docs for
  more information
  """
  use Brando.Menu
  import Brando.News.Gettext

  menu %{
    name: gettext("News"), anchor: "news", icon: "fa fa-newspaper-o icon",
      submenu: [%{name: gettext("Index"), url: {:admin_post_path, :index}},
                %{name: gettext("Add new"), url: {:admin_post_path, :new}}]}
end
