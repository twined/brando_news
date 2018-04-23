defmodule <%= application_module %>.News.Gallery do
  @moduledoc """
  Ecto schema for the Gallery schema.
  This schema connects a post and an image series
  """

  @type t :: %__MODULE__{}

  use <%= application_module %>Web, :schema
  import <%= application_module %>Web.Gettext

  @required_fields ~w(post_id imageseries_id creator_id)a

  schema "news_posts_imageseries" do
    belongs_to :post, <%= application_module %>.News.Post
    belongs_to :imageseries, Brando.ImageSeries
    belongs_to :creator, Brando.User
    timestamps()
  end

  @doc """
  Casts and validates `params` against `schema` to create a valid
  changeset when action is :create.

  ## Example

      schema_changeset = changeset(%__MODULE__{}, :create, params)

  """
  @spec changeset(t, Keyword.t | Options.t) :: t
  def changeset(schema, params \\ %{}) do
    schema
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
  end

  #
  # Meta

  use Brando.Meta.Schema, [
    singular: gettext("attached gallery"),
    plural: gettext("attached galleries"),
    repr: &("#{&1.id}"),
    fields: [
      id: "№",
      creator: gettext("Creator"),
      post: gettext("Post"),
      imageseries: gettext("Image series"),
      inserted_at: gettext("Inserted at"),
      updated_at: gettext("Updated at"),
    ]
  ]
end
