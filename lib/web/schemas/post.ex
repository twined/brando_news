defmodule Brando.News.Post do
  @moduledoc """
  Ecto schema for the Post schema, as well as image field definitions
  and helper functions for dealing with the post schema.
  """

  @type t :: %__MODULE__{}

  use Brando.Web, :schema
  use Brando.Tag, :schema
  use Brando.Villain, :schema
  use Brando.Field.ImageField

  alias Brando.Type.Status
  alias Brando.Tag

  import Brando.News.Gettext

  @required_fields ~w(status language featured header slug creator_id)a
  @optional_fields ~w(lead publish_at tags data cover html)a

  schema "news_posts" do
    field :language, :string
    field :header, :string
    field :slug, :string
    field :lead, :string
    villain()
    field :cover, Brando.Type.Image
    field :status, Status
    belongs_to :creator, Brando.User
    field :meta_description, :string
    field :meta_keywords, :string
    field :featured, :boolean
    field :publish_at, :naive_datetime
    timestamps()
    tags()
  end

  has_image_field :cover,
    %{allowed_mimetypes: ["image/jpeg", "image/png"],
      default_size: :medium,
      upload_path: Path.join(["images", "posts", "covers"]),
      random_filename: true,
      size_limit: 10240000,
      sizes: %{
        "small" =>  %{"size" => "300", "quality" => 100},
        "medium" => %{"size" => "700", "quality" => 100},
        "large" =>  %{"size" => "900", "quality" => 100},
        "xlarge" => %{"size" => "1400", "quality" => 100},
        "thumb" =>  %{"size" => "150x150", "quality" => 100, "crop" => true},
        "micro" =>  %{"size" => "25x25", "quality" => 100, "crop" => true}
      }
    }

  @doc """
  Casts and validates `params` against `schema` to create a valid
  changeset when action is :create.

  ## Example

      schema_changeset = changeset(%__MODULE__{}, :create, params)

  """
  @spec changeset(t, atom, Keyword.t | Options.t) :: t
  def changeset(schema, action, params \\ %{})
  def changeset(schema, :create, params) do
    params =
      params
      |> Tag.split_tags()

    schema
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_upload({:image, :cover})
    |> generate_html()
  end

  @doc """
  Casts and validates `params` against `schema` to create a valid
  changeset when action is :update.

  ## Example

      schema_changeset = changeset(%__MODULE__{}, :update, params)

  """
  @spec changeset(t, atom, Keyword.t | Options.t) :: t
  def changeset(schema, :update, params) do
    params = Tag.split_tags(params)

    schema
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_upload({:image, :cover})
    |> generate_html()
    |> cleanup_old_images()
  end

  @doc """
  Encode :data field in `params` as json if it's a list.
  """
  def encode_data(params) do
    if is_list(params.data) do
      Map.put(params, :data, Poison.encode!(params.data))
    else
      params
    end
  end

  @doc """
  Order posts
  """
  def order(query) do
    from m in query,
      order_by: [asc: m.status, desc: m.featured, desc: m.inserted_at]
  end

  @doc """
  Preloads :creator field
  """
  def preload_creator(query) do
    from m in query, preload: [:creator]
  end

  #
  # Meta

  use Brando.Meta.Schema, [
    singular: gettext("post"),
    plural: gettext("posts"),
    repr: &("#{&1.header}"),
    fields: [
      id: "№",
      status: gettext("Status"),
      featured: gettext("Featured"),
      language: gettext("Language"),
      cover: gettext("Cover"),
      header: gettext("Header"),
      slug: gettext("Slug"),
      lead: gettext("Lead"),
      data: gettext("Data"),
      html: gettext("HTML"),
      creator: gettext("Creator"),
      meta_description: gettext("META description"),
      meta_keywords: gettext("META keywords"),
      publish_at: gettext("Publish at"),
      tags: gettext("Tags"),
      inserted_at: gettext("Inserted at"),
      updated_at: gettext("Updated at"),
    ],
    help: [
      featured: gettext("The post is prioritized, taking precedence over pub. date"),
      cover: gettext("Photo attached to the news post, if your frontend supports it.")
    ]
  ]
end
