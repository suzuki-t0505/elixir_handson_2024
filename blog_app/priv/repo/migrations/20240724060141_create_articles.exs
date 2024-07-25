defmodule BlogApp.Repo.Migrations.CreateArticles do
  use Ecto.Migration

  def change do
    create table(:articles) do
      add :title, :string, null: false
      add :body, :text
      add :status, :integer, null: false
      add :submit_date, :date
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:articles, [:user_id])
  end
end
