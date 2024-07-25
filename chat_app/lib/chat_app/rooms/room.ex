defmodule ChatApp.Rooms.Room do
  use Ecto.Schema
  import Ecto.Changeset

  alias ChatApp.Accounts.User

  schema "rooms" do
    field :room_name, :string

    timestamps(type: :utc_datetime)

    many_to_many(:users, User, join_through: "members")
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:room_name])
    |> validate_required([:room_name])
  end
end
