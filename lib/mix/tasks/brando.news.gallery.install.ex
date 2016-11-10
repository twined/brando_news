defmodule Mix.Tasks.BrandoNews.Gallery.Install do
  use Mix.Task
  import Mix.Ecto
  import Mix.Generator

  @moduledoc """
  Install gallery migrations for posts
  """

  @shortdoc "Generates files for Brando News Gallery."

  @new [
    # Migration files
    {:eex,  "templates/brando.news.gallery.install/priv/repo/migrations/posts_imageseries_migration.exs",
            "priv/repo/migrations/timestamp_create_posts_imageseries.exs"},
    {:copy, "templates/brando.news.gallery.install/web/static/js/admin/news.js",
            "web/static/js/admin/news.js"},
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
    ensure_started(repo, args)
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
        :eex  -> contents = EEx.eval_string(render(source), binding, file: source)
                 create_file(target, contents)
        :copy -> File.mkdir_p!(Path.dirname(target))
                 File.copy!(Path.join(@root, source), target)
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
