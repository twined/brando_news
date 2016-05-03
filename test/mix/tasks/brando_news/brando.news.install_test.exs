Code.require_file "../../../support/mix_helper.exs", __DIR__

defmodule Mix.Tasks.BrandoNews.InstallTest do
  use ExUnit.Case, async: true

  import MixHelper

  @app_name  "photo_blog"
  @tmp_path  tmp_path()
  @project_path Path.join(@tmp_path, @app_name)

  setup_all do
    templates_path = Path.join([@project_path, "deps", "brando_news",
                                "web", "templates"])
    root_path =  File.cwd!

    # Clean up
    File.rm_rf @project_path

    # Create path for app
    File.mkdir_p Path.join(@project_path, "web")

    # Create path for templates
    File.mkdir_p templates_path

    # Copy templates into `deps/?/templates`
    # to mimic a real Phoenix application
    File.cp_r! Path.join([root_path, "web", "templates"]), templates_path

    # Move into the project directory to run the generator
    File.cd! @project_path
  end

  test "brando.news.install" do
    Mix.Tasks.BrandoNews.Install.run([])
    assert_received {:mix_shell, :info, ["\nBrando News finished installing."]}
    assert [migration_file] =
      Path.wildcard("priv/repo/migrations/*_create_posts.exs")

    # check timestamps not overlapping
    migration_timestamps =
      Path.wildcard("priv/repo/migrations/*.exs")
      |> Enum.map(&Path.basename/1)
      |> Enum.map(&String.split(&1, "_"))
      |> Enum.map(&List.first/1)

    migration_timestamps_after_uniq =
      migration_timestamps
      |> Enum.uniq

    assert Enum.count(migration_timestamps) == Enum.count(migration_timestamps_after_uniq)

    assert_file migration_file, fn file ->
      assert file =~ "defmodule BrandoNews.Repo.Migrations.CreatePosts"
      assert file =~ "use Brando.Villain, :migration"
      assert file =~ "villain"
    end
  end
end
