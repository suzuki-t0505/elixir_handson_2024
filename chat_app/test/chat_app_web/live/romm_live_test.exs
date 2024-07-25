defmodule ChatAppWeb.RommLiveTest do
  use ChatAppWeb.ConnCase

  import Phoenix.LiveViewTest
  import ChatApp.RoomsFixtures

  @create_attrs %{room_name: "some room_name"}
  @update_attrs %{room_name: "some updated room_name"}
  @invalid_attrs %{room_name: nil}

  defp create_romm(_) do
    romm = romm_fixture()
    %{romm: romm}
  end

  describe "Index" do
    setup [:create_romm]

    test "lists all romms", %{conn: conn, romm: romm} do
      {:ok, _index_live, html} = live(conn, ~p"/romms")

      assert html =~ "Listing Romms"
      assert html =~ romm.room_name
    end

    test "saves new romm", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/romms")

      assert index_live |> element("a", "New Romm") |> render_click() =~
               "New Romm"

      assert_patch(index_live, ~p"/romms/new")

      assert index_live
             |> form("#romm-form", romm: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#romm-form", romm: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/romms")

      html = render(index_live)
      assert html =~ "Romm created successfully"
      assert html =~ "some room_name"
    end

    test "updates romm in listing", %{conn: conn, romm: romm} do
      {:ok, index_live, _html} = live(conn, ~p"/romms")

      assert index_live |> element("#romms-#{romm.id} a", "Edit") |> render_click() =~
               "Edit Romm"

      assert_patch(index_live, ~p"/romms/#{romm}/edit")

      assert index_live
             |> form("#romm-form", romm: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#romm-form", romm: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/romms")

      html = render(index_live)
      assert html =~ "Romm updated successfully"
      assert html =~ "some updated room_name"
    end

    test "deletes romm in listing", %{conn: conn, romm: romm} do
      {:ok, index_live, _html} = live(conn, ~p"/romms")

      assert index_live |> element("#romms-#{romm.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#romms-#{romm.id}")
    end
  end

  describe "Show" do
    setup [:create_romm]

    test "displays romm", %{conn: conn, romm: romm} do
      {:ok, _show_live, html} = live(conn, ~p"/romms/#{romm}")

      assert html =~ "Show Romm"
      assert html =~ romm.room_name
    end

    test "updates romm within modal", %{conn: conn, romm: romm} do
      {:ok, show_live, _html} = live(conn, ~p"/romms/#{romm}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Romm"

      assert_patch(show_live, ~p"/romms/#{romm}/show/edit")

      assert show_live
             |> form("#romm-form", romm: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#romm-form", romm: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/romms/#{romm}")

      html = render(show_live)
      assert html =~ "Romm updated successfully"
      assert html =~ "some updated room_name"
    end
  end
end
