# Brando News

[![Coverage Status](https://coveralls.io/repos/github/twined/brando_news/badge.svg?branch=master)](https://coveralls.io/github/twined/brando_news?branch=master)

## Installation

Add brando_news to your list of dependencies in `mix.exs`:

```diff
    def deps do
      [
        {:brando, github: "twined/brando"},
+       {:brando_news, github: "twined/brando_news", branch: "develop"}
      ]
    end
```

Install migrations and frontend files:

    $ mix brando_news.install

Run migrations

    $ mix ecto.migrate

Add to your `assets/backend/src/routes/index.js`

```diff
+ import posts from './posts'

  export default [].concat(
    dashboard,
+   posts
  )
```

Add to your `assets/backend/src/menus/index.js`

```diff
+ import posts from './posts'

  export function installMenus (store) {
    store.commit('menu/STORE_MENU', [].concat(
+     posts
    ))
}
```

Add to your `assets/backend/src/store/index.js`

```diff
+ import { posts } from './modules/posts'

  # ...

  const store = new Vuex.Store({
    modules: {
      posts,
      ...kurtzBaseStoreModules
    },
    strict: debug
  })
```

And to your `lib/my_app_web/channels/admin_channel.ex`

```elixir
alias Brando.News

def handle_in("post:delete", %{"id" => id}, socket) do
  {:ok, _} = News.delete_post(id)
  {:reply, {:ok, %{status: 200}}, socket}
end

def handle_in("gallery:create", params, socket) do
  {:ok, gallery} = News.create_gallery(params)
  gallery = Map.merge(gallery, %{imageseries: %{id: gallery.imageseries_id}, creator: nil, post: nil})
  {:reply, {:ok, %{status: 200, gallery: gallery}}, socket}
end

def handle_in("gallery:delete", %{"id" => id}, socket) do
  News.delete_gallery(id)
  {:reply, {:ok, %{status: 200}}, socket}
end

```

Add to your `lib/my_app/graphql/schema.ex`

```diff
+ import_types Brando.News.Schema.Types.Post
  query do
    import_brando_queries()

    # local queries
    import_fields :client_queries
+   import_fields :post_queries
    import_fields :project_queries
    import_fields :illustrator_queries
  end

  mutation do
    import_brando_mutations()

    # local mutations
    import_fields :client_mutations
+   import_fields :post_mutations
    import_fields :illustrator_mutations
  end
```

If you need to customize the schema, just copy it from the `brando_news` sourcecode and
import it like above but from your local module
