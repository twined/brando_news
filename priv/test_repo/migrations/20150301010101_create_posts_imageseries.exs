defmodule BrandoNews.Integration.TestRepo.Migrations.CreateGalleryPosts do
  use Ecto.Migration

  def up do
    create table(:news_posts_imageseries) do
      add :post_id,        references(:news_posts, on_delete: :delete_all)
      add :imageseries_id, references(:imageseries, on_delete: :delete_all)
      add :creator_id,     references(:users)
      timestamps()
    end
  end

  def down do
    drop table(:news_posts_imageseries)
  end
end
