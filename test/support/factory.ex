defmodule BrandoNews.Factory do
  use ExMachina.Ecto, repo: Brando.repo

  alias Brando.User

  def user_factory do
    %User{
      full_name: "James Williamson",
      email: "james@thestooges.com",
      password: "$2b$12$VD9opg289oNQAHii8VVpoOIOe.y4kx7.lGb9SYRwscByP.tRtJTsa",
      avatar: nil,
      role: :admin,
      active: true,
      language: "en"
    }
  end
end
