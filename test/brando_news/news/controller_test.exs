defmodule BrandoNews.ControllerTest do
  use ExUnit.Case
  use BrandoNews.ConnCase
  use Plug.Test
  use RouterHelper

  alias BrandoNews.Factory

  test "index" do
    conn =
      :get
      |> call("/admin/news")
      |> with_user
      |> send_request

    assert response_content_type(conn, :html) =~ "charset=utf-8"
    assert html_response(conn, 200) =~ "Index - posts"
  end

  test "show" do
    user = Factory.insert(:user)
    post = Factory.insert(:post, creator: user)

    conn =
      :get
      |> call("/admin/news/#{post.id}")
      |> with_user
      |> send_request

    assert html_response(conn, 200) =~ "Header"
  end

  test "rerender" do
    user = Factory.insert(:user)
    Factory.insert(:post, creator: user)

    conn =
      :get
      |> call("/admin/news/rerender")
      |> with_user
      |> send_request

    assert redirected_to(conn, 302) =~ "/admin/news"
    assert get_flash(conn, :notice) == "Posts re-rendered"
  end

  test "new" do
    conn =
      :get
      |> call("/admin/news/new")
      |> with_user
      |> send_request

    assert html_response(conn, 200) =~ "New post"
  end

  test "edit" do
    user = Factory.insert(:user)
    post = Factory.insert(:post, creator: user)

    conn =
      :get
      |> call("/admin/news/#{post.id}/edit")
      |> with_user
      |> send_request

    assert html_response(conn, 200) =~ "Edit post"

    assert_raise Plug.Conn.WrapperError, fn ->
      :get
      |> call("/admin/news/1234/edit")
      |> with_user
      |> send_request
    end
  end

  test "create (post) w/params" do
    user = Factory.insert(:user)
    post_params = Factory.params_for(:post, creator_id: user.id)

    conn =
      :post
      |> call("/admin/news/", %{"post" => post_params})
      |> with_user(user)
      |> send_request

    assert redirected_to(conn, 302) =~ "/admin/news"
  end

  test "create (post) w/erroneus params" do
    user = Factory.insert(:user)
    post_params =
      :post
      |> Factory.params_for(%{creator_id: user.id})
      |> Map.delete(:data)
      |> Map.delete(:header)
      
    conn =
      :post
      |> call("/admin/news/", %{"post" => post_params})
      |> with_user
      |> send_request

    assert html_response(conn, 200) =~ "New post"
    assert get_flash(conn, :error) == "Errors in form"
  end


  test "update (post) w/params" do
    user = Factory.insert(:user)
    post = Factory.insert(:post, creator: user)

    post_params =
      Factory.params_for(
        :post,
        creator_id: user.id,
        data: ~s([{"type":"text","data":{"text":"zcxvxcv","type":"paragraph"}}])
      )

    conn =
      :patch
      |> call("/admin/news/#{post.id}", %{"post" => post_params})
      |> with_user(user)
      |> send_request

    assert redirected_to(conn, 302) =~ "/admin/news"
  end

  test "update (post) w/erroneus params" do
    user = Factory.insert(:user)
    post = Factory.insert(:post, creator: user)

    post_params =
      :post
      |> Factory.params_for(creator: user)
      |> Map.put("header", "")
      |> Map.put("data", ~s([{"type":"text","data":{"text":"zcxvxcv","type":"paragraph"}}]))

    conn =
      :patch
      |> call("/admin/news/#{post.id}", %{"post" => post_params})
      |> with_user(user)
      |> send_request

    assert html_response(conn, 200) =~ "Edit post"
    assert get_flash(conn, :error) == "Errors in form"
  end

  test "delete_confirm" do
    user = Factory.insert(:user)
    post = Factory.insert(:post, creator: user)

    conn =
      :get
      |> call("/admin/news/#{post.id}/delete")
      |> with_user
      |> send_request

    assert html_response(conn, 200) =~ "Delete post: Post title"
  end

  test "delete" do
    user = Factory.insert(:user)
    post = Factory.insert(:post, creator: user)

    conn =
      :delete
      |> call("/admin/news/#{post.id}")
      |> with_user
      |> send_request

    assert redirected_to(conn, 302) =~ "/admin/news"
  end

  test "uses villain" do
    funcs = Brando.Admin.PostController.__info__(:functions)
    funcs = Keyword.keys(funcs)

    assert :browse_images in funcs
    assert :upload_image in funcs
    assert :image_info in funcs
  end
end
