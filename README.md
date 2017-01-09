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

    $ mix brando_news.install

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

Add to your `lib/my_app.ex`:

```diff
    def start(_type, _args) do
      import Supervisor.Spec, warn: false

      children = [
        # Start the endpoint when the application starts
        supervisor(MyApp.Endpoint, []),
        # Start the Ecto repository
        supervisor(MyApp.Repo, []),
        # Here you could define other workers and supervisors as children
        # worker(MyApp.Worker, [arg1, arg2, arg3]),
      ]

+     Brando.Registry.register(Brando.News)
```

# Post gallery

If you want to add functionality to attach a gallery to a news post, you first have to install it:

  * `$ mix brando_news.gallery.install`
  * `$ mix ecto.migrate`
  * Add to your otp_app's `conf/brando.exs`:
    ```elixir
    config :brando, Brando.News,
      enable_galleries: true
    ```
  * Add this popup form to your otp_app's start up:
    ```elixir
    Brando.PopupForm.Registry.register(:gallery, "imageseries", Brando.ImageSeriesForm,
                                       gettext("Create gallery"), [:id, :slug])
    ```
  * Add to `web/static/js/admin/custom.js`:
    ```javascript
    import News from './news';
    ```

# Limited Villain blocks

If you want to limit the available Villain blocks in the editor, you can pass `villain_blocks` to the config:

```elixir

config :brando, Brando.News,
  villain_blocks: ["Markdown"]
```
