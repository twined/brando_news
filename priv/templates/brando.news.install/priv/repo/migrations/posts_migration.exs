defmodule <%= application_module %>.Repo.Migrations.CreatePosts do
  use Ecto.Migration
  use Brando.Tag, :migration
  use Brando.Villain, :migration

  def up do
    create table(:news_posts) do
      add :language,          :text
      add :header,            :text
      add :slug,              :text
      add :lead,              :text
      villain()
      add :cover,             :text
      add :status,            :integer
      add :creator_id,        references(:users)
      add :meta_description,  :text
      add :meta_keywords,     :text
      add :css_classes,       :text
      add :featured,          :boolean
      add :publish_at,        :datetime
      tags()
      timestamps()
    end
    create index(:news_posts, [:language])
    create index(:news_posts, [:slug])
    create index(:news_posts, [:status])
    create index(:news_posts, [:tags])
  end

  def down do
    drop table(:news_posts)
    drop index(:news_posts, [:language])
    drop index(:news_posts, [:slug])
    drop index(:news_posts, [:status])
  end
end
