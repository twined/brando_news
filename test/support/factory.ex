defmodule BrandoNews.Factory do
  use ExMachina.Ecto, repo: Brando.repo

  alias Brando.User
  alias Brando.Post

  def factory(:user) do
    %User{
      full_name: "James Williamson",
      email: "james@thestooges.com",
      password: "$2b$12$VD9opg289oNQAHii8VVpoOIOe.y4kx7.lGb9SYRwscByP.tRtJTsa",
      username: "jamesw",
      avatar: nil,
      role: [:admin, :superuser],
      language: "en"
    }
  end

  def factory(:post) do
    %Post{
      language: "en",
      header: "Post title",
      lead: "This is the lead",
      featured: false,
      slug: "post-title",
      data: ~s([{"type":"text","data":{"text":"Text in p.","type":"paragraph"}}]),
      html: ~s(<p>Text in p.</p>),
      status: :published,
      creator: build(:user),
    }
  end

  def factory(:post_params) do
    %{
      "language" => "en",
      "header" => "Post title",
      "lead" => "This is the lead",
      "featured" => false,
      "slug" => "post-title",
      "data" => ~s([{"type":"text","data":{"text":"Text in p.","type":"paragraph"}}]),
      "html" => ~s(<p>Text in p.</p>),
      "status" => :published
    }
  end
end
