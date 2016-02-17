Code.require_file("support/router_helper.exs", __DIR__)

{:ok, _} = Application.ensure_all_started(:brando)
{:ok, _} = Application.ensure_all_started(:ecto)
{:ok, _} = Application.ensure_all_started(:ex_machina)

Brando.Registry.wipe()
Brando.Registry.register(Brando.News)

ExUnit.start()

defmodule BrandoNews.Integration.Repo do
  defmacro __using__(opts) do
    quote do
      use Ecto.Repo, unquote(opts)
      def log(cmd) do
        super(cmd)
        on_log = Process.delete(:on_log) || fn -> :ok end
        on_log.()
      end
    end
  end
end

defmodule BrandoNews.Integration.TestRepo do
  use BrandoNews.Integration.Repo, otp_app: :brando_news
end

defmodule BrandoNews.Integration.Endpoint do
  use Phoenix.Endpoint,
    otp_app: :brando_news

  plug Plug.Session,
    store: :cookie,
    key: "_test",
    signing_salt: "signingsalt"

  plug Plug.Static,
    at: "/", from: :brando_news, gzip: false,
    only: ~w(css images js fonts favicon.ico robots.txt),
    cache_control_for_vsn_requests: nil,
    cache_control_for_etags: nil
end

Mix.Ecto.ensure_started(Brando.repo)

Mix.Task.run "ecto.create", ["-r", Brando.repo, "--quiet"]
Mix.Task.run "ecto.migrate", ["-r", Brando.repo, "--quiet"]
Ecto.Adapters.SQL.begin_test_transaction(Brando.repo)
Brando.endpoint.start_link
