Code.require_file "../../../support/mix_helper.exs", __DIR__

defmodule Mix.Tasks.BrandoNews.Gallery.InstallTest do
  use ExUnit.Case, async: true
  use BrandoNews.ConnCase
  import MixHelper
  alias BrandoNews.Factory

  @app_name  "photo_blog_extra"
  @tmp_path  tmp_path()
  @project_path Path.join(@tmp_path, @app_name)

  setup_all do
    templates_path = Path.join([@project_path, "deps", "brando_news",
                                "lib", "web", "templates"])
    root_path =  File.cwd!

    # Clean up
    File.rm_rf @project_path

    # Create path for app
    File.mkdir_p Path.join([@project_path, "lib", "web", "templates"])

    # Create path for templates
    File.mkdir_p templates_path

    # Copy templates into `deps/?/templates`
    # to mimic a real Phoenix application
    File.cp_r! Path.join([root_path, "lib", "web", "templates"]), templates_path

    # Move into the project directory to run the generator
    File.cd! @project_path
  end

  test "brando.news.gallery.install" do
    _ = Factory.insert(:user)
    Mix.Tasks.BrandoNews.Gallery.Install.run(["-r", "BrandoNews.Integration.TestRepo"])
    assert_received {:mix_shell, :info, ["\nBrando News Gallery finished installing."]}
    assert [migration_file] =
      Path.wildcard("priv/repo/migrations/*_create_posts.exs")

    assert_file migration_file, fn file ->
      assert file =~ "defmodule BrandoNews.Repo.Migrations.CreatePosts"
      assert file =~ "use Brando.Villain, :migration"
      assert file =~ "villain"
    end

    assert [js_file] =
      Path.wildcard("assets/js/admin/news.js")

    assert_file js_file, fn file ->
      assert file =~ "class News {"
    end
  end
end
