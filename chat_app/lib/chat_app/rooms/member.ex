defmodule ChatApp.Rooms.Member do
  use Ecto.Schema
  import Ecto.Changeset

  alias ChatApp.Accounts.User
  alias ChatApp.Rooms.Room

  schema "members" do
    belongs_to(:user, User)
    belongs_to(:room, Room)

    timestamps(type: :utc_datetime, updated_at: false)
  end

  @doc false
  def changeset(member, attrs) do
    member
    |> cast(attrs, [:user_id, :room_id])
  end
end
