defmodule ChatApp.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :message, :string
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :room_id, references(:rooms, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime, updated_at: false)
    end

    create index(:messages, [:user_id])
    create index(:messages, [:room_id])
  end
end
