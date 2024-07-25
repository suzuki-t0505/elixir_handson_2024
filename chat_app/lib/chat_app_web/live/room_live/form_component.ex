defmodule ChatAppWeb.RoomLive.FormComponent do
  use ChatAppWeb, :live_component

  alias ChatApp.Rooms

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage room records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="room-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:room_name]} type="text" label="Room name" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Room</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{room: room} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Rooms.change_room(room))
     end)}
  end

  @impl true
  def handle_event("validate", %{"room" => room_params}, socket) do
    changeset = Rooms.change_room(socket.assigns.room, room_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"room" => room_params}, socket) do
    save_room(socket, socket.assigns.action, room_params)
  end

  defp save_room(socket, :edit, room_params) do
    case Rooms.update_room(socket.assigns.room, room_params) do
      {:ok, room} ->
        notify_parent({:saved, room})

        {:noreply,
         socket
         |> put_flash(:info, "Room updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_room(socket, :new, room_params) do
    case Rooms.create_room(socket.assigns.current_user.id, room_params) do
      {:ok, %{room: room}} ->
        {:noreply,
         socket
         |> put_flash(:info, "Room created successfully")
         |> redirect(to: ~p"/rooms/#{room}")}

      {:error, :room, %Ecto.Changeset{} = changeset, %{}} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
