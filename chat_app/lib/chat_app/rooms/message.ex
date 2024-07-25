defmodule ChatApp.Rooms.Message do
  use Ecto.Schema
  import Ecto.Changeset

  alias ChatApp.Accounts.User
  alias ChatApp.Rooms.Room

  schema "messages" do
    field :message, :string
    belongs_to(:user, User)
    belongs_to(:room, Room)

    timestamps(type: :utc_datetime, updated_at: false)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:message, :user_id, :room_id])
    |> validate_required([:message])
  end
end
