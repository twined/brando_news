defmodule BrandoNews.PostTest do
  use ExUnit.Case
  use BrandoNews.SchemaCase

  alias Brando.News.Post
  alias BrandoNews.Factory

  setup do
    user = Factory.insert(:user)
    post = Factory.insert(:post, creator: user)

    {:ok, %{user: user, post: post}}
  end

  test "meta", %{post: post} do
    assert Post.__name__(:singular) == "post"
    assert Post.__name__(:plural) == "posts"
    assert Post.__repr__(post) == "Post title"
  end

  test "encode_data" do
    assert Post.encode_data(%{data: "test"}) == %{data: "test"}
    assert Post.encode_data(%{data: [%{key: "value"}, %{key2: "value2"}]})
           == %{data: ~s([{"key":"value"},{"key2":"value2"}])}
  end
end
