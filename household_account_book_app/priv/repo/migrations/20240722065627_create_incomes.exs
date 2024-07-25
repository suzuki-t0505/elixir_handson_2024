defmodule HouseholdAccountBookApp.Repo.Migrations.CreateIncomes do
  use Ecto.Migration

  def change do
    create table(:incomes) do
      add :money, :integer
      add :date, :date

      timestamps(type: :utc_datetime)
    end
  end
end
