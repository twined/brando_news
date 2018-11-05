defmodule Mix.Tasks.BrandoNews.Install do
  use Mix.Task
  import Mix.Ecto
  import Mix.Generator

  @moduledoc """
  Install Brando.
  """

  @shortdoc "Generates files for Brando News."

  @new [
    # Migration files
    {:eex,  "templates/brando.news.install/priv/repo/migrations/posts_migration.exs",
            "priv/repo/migrations/timestamp_create_posts.exs"},
    {:eex,  "templates/brando.news.install/priv/repo/migrations/posts_imageseries_migration.exs",
            "priv/repo/migrations/timestamp_create_posts_imageseries.exs"},

    # Schemas
    {:eex,  "templates/brando.news.install/lib/application_name/news/gallery.ex",
            "lib/application_name/news/gallery.ex"},
    {:eex,  "templates/brando.news.install/lib/application_name/news/post.ex",
            "lib/application_name/news/post.ex"},

    # Context
    {:eex,  "templates/brando.news.install/lib/application_name/news/news.ex",
            "lib/application_name/news/news.ex"},

    # GraphQL
    {:eex,  "templates/brando.news.install/lib/application_name/graphql/schema/types/post.ex",
            "lib/application_name/graphql/schema/types/post.ex"},
    {:eex,  "templates/brando.news.install/lib/application_name/graphql/resolvers/post_resolver.ex",
            "lib/application_name/graphql/resolvers/post_resolver.ex"},

    # Vue/JS files
    {:copy, "templates/brando.news.install/assets/backend/src/api/graphql/posts/CREATE_POST_MUTATION.graphql",
            "assets/backend/src/api/graphql/posts/CREATE_POST_MUTATION.graphql"},
    {:copy, "templates/brando.news.install/assets/backend/src/api/graphql/posts/POSTS_QUERY.graphql",
            "assets/backend/src/api/graphql/posts/POSTS_QUERY.graphql"},
    {:copy, "templates/brando.news.install/assets/backend/src/api/graphql/posts/POST_QUERY.graphql",
            "assets/backend/src/api/graphql/posts/POST_QUERY.graphql"},
    {:copy, "templates/brando.news.install/assets/backend/src/api/graphql/posts/UPDATE_POST_MUTATION.graphql",
            "assets/backend/src/api/graphql/posts/UPDATE_POST_MUTATION.graphql"},
    {:copy, "templates/brando.news.install/assets/backend/src/api/post.js",
            "assets/backend/src/api/post.js"},
    {:copy, "templates/brando.news.install/assets/backend/src/menus/posts.js",
            "assets/backend/src/menus/posts.js"},
    {:copy, "templates/brando.news.install/assets/backend/src/routes/posts.js",
            "assets/backend/src/routes/posts.js"},
    {:copy, "templates/brando.news.install/assets/backend/src/store/modules/posts.js",
            "assets/backend/src/store/modules/posts.js"},
    {:copy, "templates/brando.news.install/assets/backend/src/views/news/PostCreateView.vue",
            "assets/backend/src/views/news/PostCreateView.vue"},
    {:copy, "templates/brando.news.install/assets/backend/src/views/news/PostEditView.vue",
            "assets/backend/src/views/news/PostEditView.vue"},
    {:copy, "templates/brando.news.install/assets/backend/src/views/news/PostListView.vue",
            "assets/backend/src/views/news/PostListView.vue"},
  ]

  @static []

  @root Path.expand("../../../priv", __DIR__)

  for {format, source, _} <- @new ++ @static do
    unless format in [:keep, :copy] do
      @external_resource Path.join(@root, source)
      def render(unquote(source)), do: unquote(File.read!(Path.join(@root, source)))
    end
  end

  def run(args) do
    repo = parse_repo(args) |> List.first
    ensure_repo(repo, args)
    Application.ensure_started(repo, args)
    app = Mix.Project.config()[:app]
    binding = [application_module: Phoenix.Naming.camelize(Atom.to_string(app)),
               application_name: Atom.to_string(app)]

    copy_from "./", binding, @new

    creator = repo.all(Brando.User) |> List.first

    # Add a "Galleries" category to images.
    Brando.ImageCategory.changeset(%Brando.ImageCategory{}, :create, %{
      name: "Post galleries",
      slug: "post-galleries",
      creator_id: creator.id
    })
    |> repo.insert!

    Mix.shell.info "\nBrando News Gallery finished installing."

    app = Mix.Project.config()[:app]
    binding = [application_module: Phoenix.Naming.camelize(Atom.to_string(app)),
               application_name: Atom.to_string(app)]

    copy_from "./", binding, @new

    Mix.shell.info "\nBrando News finished installing."
  end

  defp copy_from(target_dir, binding, mapping) when is_list(mapping) do
    application_name = Keyword.fetch!(binding, :application_name)
    for {{format, source, target_path}, counter} <- Enum.with_index(mapping) do
      target_path =
        target_path
        |> String.replace("application_name", application_name)

      target_path = if String.contains?(target_path, "timestamp") do
        :timer.sleep(10)
        String.replace(target_path, "timestamp", timestamp(counter))
      else
        target_path
      end

      target = Path.join(target_dir, target_path)

      case format do
        :copy ->
          File.mkdir_p!(Path.dirname(target))
          File.copy!(Path.join(@root, source), target)
        :eex  ->
          contents = EEx.eval_string(render(source), binding, file: source)
          create_file(target, contents)
      end
    end
  end

  defp timestamp(offset) do
    {{y, m, d}, {hh, mm, ss}} = :calendar.universal_time()
    {mm, ss} = if ss + offset < 60 do
      {mm, ss + offset}
    else
      {mm + 1, offset - (60 - ss)}
    end
    "#{y}#{pad(m)}#{pad(d)}#{pad(hh)}#{pad(mm)}#{pad(ss)}"
  end

  defp pad(i) when i < 10, do: << ?0, ?0 + i >>
  defp pad(i), do: to_string(i)
end
