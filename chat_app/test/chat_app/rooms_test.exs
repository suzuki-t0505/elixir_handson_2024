defmodule ChatApp.RoomsTest do
  use ChatApp.DataCase

  alias ChatApp.Rooms

  describe "romms" do
    alias ChatApp.Rooms.Romm

    import ChatApp.RoomsFixtures

    @invalid_attrs %{room_name: nil}

    test "list_romms/0 returns all romms" do
      romm = romm_fixture()
      assert Rooms.list_romms() == [romm]
    end

    test "get_romm!/1 returns the romm with given id" do
      romm = romm_fixture()
      assert Rooms.get_romm!(romm.id) == romm
    end

    test "create_romm/1 with valid data creates a romm" do
      valid_attrs = %{room_name: "some room_name"}

      assert {:ok, %Romm{} = romm} = Rooms.create_romm(valid_attrs)
      assert romm.room_name == "some room_name"
    end

    test "create_romm/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Rooms.create_romm(@invalid_attrs)
    end

    test "update_romm/2 with valid data updates the romm" do
      romm = romm_fixture()
      update_attrs = %{room_name: "some updated room_name"}

      assert {:ok, %Romm{} = romm} = Rooms.update_romm(romm, update_attrs)
      assert romm.room_name == "some updated room_name"
    end

    test "update_romm/2 with invalid data returns error changeset" do
      romm = romm_fixture()
      assert {:error, %Ecto.Changeset{}} = Rooms.update_romm(romm, @invalid_attrs)
      assert romm == Rooms.get_romm!(romm.id)
    end

    test "delete_romm/1 deletes the romm" do
      romm = romm_fixture()
      assert {:ok, %Romm{}} = Rooms.delete_romm(romm)
      assert_raise Ecto.NoResultsError, fn -> Rooms.get_romm!(romm.id) end
    end

    test "change_romm/1 returns a romm changeset" do
      romm = romm_fixture()
      assert %Ecto.Changeset{} = Rooms.change_romm(romm)
    end
  end

  describe "rooms" do
    alias ChatApp.Rooms.Room

    import ChatApp.RoomsFixtures

    @invalid_attrs %{room_name: nil}

    test "list_rooms/0 returns all rooms" do
      room = room_fixture()
      assert Rooms.list_rooms() == [room]
    end

    test "get_room!/1 returns the room with given id" do
      room = room_fixture()
      assert Rooms.get_room!(room.id) == room
    end

    test "create_room/1 with valid data creates a room" do
      valid_attrs = %{room_name: "some room_name"}

      assert {:ok, %Room{} = room} = Rooms.create_room(valid_attrs)
      assert room.room_name == "some room_name"
    end

    test "create_room/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Rooms.create_room(@invalid_attrs)
    end

    test "update_room/2 with valid data updates the room" do
      room = room_fixture()
      update_attrs = %{room_name: "some updated room_name"}

      assert {:ok, %Room{} = room} = Rooms.update_room(room, update_attrs)
      assert room.room_name == "some updated room_name"
    end

    test "update_room/2 with invalid data returns error changeset" do
      room = room_fixture()
      assert {:error, %Ecto.Changeset{}} = Rooms.update_room(room, @invalid_attrs)
      assert room == Rooms.get_room!(room.id)
    end

    test "delete_room/1 deletes the room" do
      room = room_fixture()
      assert {:ok, %Room{}} = Rooms.delete_room(room)
      assert_raise Ecto.NoResultsError, fn -> Rooms.get_room!(room.id) end
    end

    test "change_room/1 returns a room changeset" do
      room = room_fixture()
      assert %Ecto.Changeset{} = Rooms.change_room(room)
    end
  end
end
