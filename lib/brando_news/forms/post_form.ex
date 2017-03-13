defmodule Brando.PostForm do
  @moduledoc """
  A form for the Post schema. See the `Brando.Form` module for more
  documentation
  """

  use Brando.Form
  alias Brando.News.Post
  import Brando.News.Gettext

  @doc false
  def get_language_choices() do
    Brando.config(:languages)
  end

  @doc false
  def get_status_choices() do
   [[value: "0", text: gettext("Draft")],
    [value: "1", text: gettext("Published")],
    [value: "2", text: gettext("Pending")],
    [value: "3", text: gettext("Deleted")]]
  end

  @doc """
  Check is status' choice is selected.
  Translates the `schema_value` from an atom to an int as string
  through `Brando.Type.Status.dump/1`.
  Returns boolean.
  """
  @spec status_selected?(String.t, atom) :: boolean
  def status_selected?(form_value, schema_value) do
    # translate value from atom to corresponding int as string
    {:ok, status_int} = Brando.Type.Status.dump(schema_value)
    form_value == to_string(status_int)
  end

  form "post", [schema: Post, helper: :admin_post_path, class: "grid-form"] do
    fieldset do
      field :language, :select,
        [default: "nb",
         choices: &__MODULE__.get_language_choices/0]
    end
    fieldset do
      field :status, :radio,
        [default: "1",
         choices: &__MODULE__.get_status_choices/0,
         is_selected: &__MODULE__.status_selected?/2]
    end
    fieldset do
      field :featured, :checkbox,
        [default: false]
    end
    fieldset do
      field :header, :text
      field :slug, :text, [slug_from: :header]
    end
    field :lead, :textarea, [required: false]
    field :data, :textarea, [
      required: false,
      default: ~s([{"type":"text","data":{"text":"Text","type":"paragraph"}}])
    ]
    field :publish_at, :datetime, [default: &Brando.Utils.get_now/0]
    field :cover, :file, [required: false]
    field :tags, :text, [tags: true, required: false]
    submit :save, [class: "btn btn-success"]
  end
end
