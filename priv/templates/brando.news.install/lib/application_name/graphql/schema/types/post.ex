defmodule <%= application_module %>.Schema.Types.Post do
  use <%= application_module %>Web, :absinthe

  object :post do
    field :id, :id
    field :status, :string
    field :language, :string
    field :header, :string
    field :slug, :string
    field :lead, :string
    field :data, :json
    field :html, :string
    field :cover, :image_type

    field :meta_description, :string
    field :meta_keywords, :string
    field :featured, :boolean
    field :publish_at, :time

    field :gallery, :gallery, resolve: assoc(:gallery)

    field :inserted_at, :time
  end

  object :gallery do
    field :id, :id
    field :post, :post, resolve: assoc(:post)
    field :imageseries, :image_series, resolve: assoc(:imageseries)
    field :creator, :user, resolve: assoc(:creator)
  end

  input_object :create_post_params do
    field :header, :string
    field :slug, :string
    field :language, :string
    field :status, :string
    field :lead, :string
    field :data, :string
    field :cover, :upload
    field :meta_description, :string
    field :meta_keywords, :string
    field :featured, :boolean
    field :publish_at, :time
  end

  input_object :update_post_params do
    field :header, :string
    field :slug, :string
    field :language, :string
    field :status, :string
    field :lead, :string
    field :data, :string
    field :cover, :upload
    field :meta_description, :string
    field :meta_keywords, :string
    field :featured, :boolean
    field :publish_at, :time
  end

  object :post_queries do
    @desc "Get all posts"
    field :posts, type: list_of(:post) do
      resolve &<%= application_module %>.News.PostResolver.all/2
    end

    @desc "Get post"
    field :post, type: :post do
      arg :post_id, non_null(:id)
      resolve &<%= application_module %>.News.PostResolver.find/2
    end
  end

  object :post_mutations do
    field :create_post, type: :post do
      arg :post_params, non_null(:create_post_params)

      resolve &<%= application_module %>.News.PostResolver.create/2
    end

    field :update_post, type: :post do
      arg :post_id, non_null(:id)
      arg :post_params, :update_post_params

      resolve &<%= application_module %>.News.PostResolver.update/2
    end
  end
end
