defmodule ChatApp.RoomsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ChatApp.Rooms` context.
  """

  @doc """
  Generate a romm.
  """
  def romm_fixture(attrs \\ %{}) do
    {:ok, romm} =
      attrs
      |> Enum.into(%{
        room_name: "some room_name"
      })
      |> ChatApp.Rooms.create_romm()

    romm
  end

  @doc """
  Generate a room.
  """
  def room_fixture(attrs \\ %{}) do
    {:ok, room} =
      attrs
      |> Enum.into(%{
        room_name: "some room_name"
      })
      |> ChatApp.Rooms.create_room()

    room
  end
end
