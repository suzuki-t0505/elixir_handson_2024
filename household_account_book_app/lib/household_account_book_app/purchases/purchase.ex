defmodule HouseholdAccountBookApp.Purchases.Purchase do
  use Ecto.Schema
  import Ecto.Changeset
  alias HouseholdAccountBookApp.Purchases.Category

  schema "purchases" do
    field :name, :string
    field :date, :date
    field :money, :integer
    belongs_to :category, Category

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(purchase, attrs) do
    purchase
    |> cast(attrs, [:name, :money, :date, :category_id])
    |> validate_required([:name, :money, :date])
  end
end
