Code.require_file "../../../support/mix_helper.exs", __DIR__

defmodule Mix.Tasks.BrandoNews.Gallery.InstallTest do
  use ExUnit.Case, async: false
  use BrandoNews.ConnCase
  import MixHelper

  alias BrandoNews.Factory

  setup do
    send self(), {:mix_shell_input, :yes?, true}
    send self(), {:mix_shell_input, :yes?, true}
    :ok
  end

  test "brando.news.install" do
    in_tmp "install", fn ->
      _ = Factory.insert(:user)
      Mix.Tasks.BrandoNews.Install.run(["-r", "BrandoNews.Integration.TestRepo"])
    end
  end
end
