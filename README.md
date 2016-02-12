# Brando News

[![Coverage Status](https://coveralls.io/repos/github/twined/brando_news/badge.svg?branch=master)](https://coveralls.io/github/twined/brando_news?branch=master)

## Installation

Add brando_news to your list of dependencies in `mix.exs`:

```diff
    def deps do
      [
        {:brando, github: "twined/brando"},
+       {:brando_news, github: "twined/brando_news"}
      ]
    end
```

Install migrations and frontend files:

    $ mix brando.news.install

Run migrations

    $ mix ecto.migrate

Add to your `web/router.ex`:

```diff

    defmodule MyApp.Router do
      use MyApp.Web, :router
      # ...
+     import Brando.News.Routes.Admin

      scope "/admin", as: :admin do
        pipe_through :admin
        dashboard_routes   "/"
        user_routes        "/users"
+       post_routes        "/news"
      end
    end
```

Add to your `config/brando.exs`:

```diff
    config :brando, Brando.Menu,
      colors: [...],
      modules: [
        Brando.Menu.Admin, 
        Brando.Menu.Users, 
+       Brando.Menu.News
      ]
```

