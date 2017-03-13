defmodule BrandoNews.Integration.TestRepo.Migrations.CreateImages do
  use Ecto.Migration
  use Brando.Sequence, :migration

  def up do
    create table(:imagecategories) do
      add :name,              :text
      add :slug,              :text
      add :cfg,               :json
      add :creator_id,        references(:users)
      timestamps()
    end
    create index(:imagecategories, [:slug])

    create table(:imageseries) do
      add :name,              :text
      add :slug,              :text
      add :credits,           :text
      add :cfg,               :json
      add :creator_id,        references(:users)
      add :image_category_id, references(:imagecategories)
      sequenced()
      timestamps()
    end
    create unique_index(:imageseries, [:slug])

    create table(:images) do
      add :image,             :text
      add :creator_id,        references(:users)
      add :image_series_id,   references(:imageseries)
      sequenced()
      timestamps()
    end
  end

  def down do
    drop table(:imagecategories)
    drop index(:imagecategories, [:slug])

    drop table(:imageseries)
    drop index(:imageseries, [:slug])

    drop table(:images)
  end
end
