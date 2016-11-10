defmodule Brando.Gallery do
  @moduledoc """
  Ecto schema for the Gallery model.
  This schema connects a post and an image series
  """

  @type t :: %__MODULE__{}

  use Brando.Web, :model

  import Brando.News.Gettext

  @required_fields ~w(post_id imageseries_id creator_id)a

  schema "posts_imageseries" do
    belongs_to :post, Brando.Post
    belongs_to :imageseries, Brando.ImageSeries
    belongs_to :creator, Brando.User
    timestamps
  end

  @doc """
  Casts and validates `params` against `model` to create a valid
  changeset when action is :create.

  ## Example

      model_changeset = changeset(%__MODULE__{}, :create, params)

  """
  @spec changeset(t, Keyword.t | Options.t) :: t
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
  end

  @doc """
  Preloads :creator field
  """
  def preload_creator(query) do
    from m in query, preload: [:creator]
  end

  #
  # Meta

  use Brando.Meta.Model, [
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
