Code.require_file "../../../support/mix_helper.exs", __DIR__

defmodule Mix.Tasks.BrandoNews.Gallery.InstallTest do
  use ExUnit.Case, async: false
  use BrandoNews.ConnCase
  import MixHelper
  alias BrandoNews.Factory

  @app_name "photo_blog"
  @tmp_path tmp_path()
  @project_path Path.join(@tmp_path, @app_name)
  @root_path Path.expand(".")

  setup_all do
    templates_path = Path.join([@project_path, "deps", "brando", "lib", "web", "templates"])

    # Clean up
    File.rm_rf @project_path

    # Create path for app
    File.mkdir_p Path.join(@project_path, "brando")

    # Create path for templates
    File.mkdir_p templates_path

    # Move into the project directory to run the generator
    File.cd! @project_path

    on_exit fn ->
      File.cd! @root_path
    end
  end

  test "brando.news.install" do
    _ = Factory.insert(:user)
    send self(), {:mix_shell_input, :yes?, true}
    Mix.Tasks.BrandoNews.Install.run(["-r", "BrandoNews.Integration.TestRepo"])
  end
end
