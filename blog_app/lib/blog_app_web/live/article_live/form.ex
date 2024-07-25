defmodule BlogAppWeb.ArticleLive.Form do
  use BlogAppWeb, :live_view
  alias BlogApp.Articles

  def render(assigns) do
    ~H"""
    <.header>
      <div><%= @page_title %></div>
    </.header>

    <.simple_form for={@form} phx-change="validate" phx-submit="save">
      <.input field={@form[:title]} type="text" label="Title" />
      <.input field={@form[:body]} type="textarea" label="Body" />
      <.input
        field={@form[:status]}
        type="select"
        label="Public Type"
        options={[{"defat", 0}, {"public", 1}, {"limited", 2}]}
      />
      <:actions>
        <.button phx-disabled-with="Saving...">
          Save
        </.button>
      </:actions>
    </.simple_form>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(params, _uri, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"article_id" => article_id}) do
    article = Articles.get_article!(article_id)

    socket
    |> assign(:page_title, "Edit Article")
    |> assign(:article, article)
    |> assign_form(Articles.change_article(article))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Article")
    |> assign(:article, %Articles.Article{})
    |> assign_form(Articles.change_article(%Articles.Article{}))
  end

  def handle_event("validate", %{"article" => params}, socket) do
    # params = %{"title" => "タイトル", "body" => "内容", status: 1}
    cs = Articles.change_article(socket.assigns.article, params)

    {:noreply, assign_form(socket, cs)}
  end

  def handle_event("save", %{"article" => params}, socket) do
    {:noreply, save_article(socket, socket.assigns.live_action, params)}
  end

  defp save_article(socket, :edit, params) do
    case Articles.update_article(socket.assigns.article, params) do
      {:ok, %Articles.Article{status: 0}} ->
        socket
        |> put_flash(:info, "Article updated successfully.")
        |> redirect(
          to: ~p"/users/profile/#{socket.assigns.current_user}/draft")
      {:ok, article} ->
        socket
        |> put_flash(:info, "Article updated successfully")
        |> redirect(to: ~p"/articles/show/#{article}")
      {:error, cs} ->
        assign_form(socket, cs)
    end
  end

  defp save_article(socket, :new, params) do
    # params = %{"title" => "タイトル", "body" => "内容", status: 1}
    params = Map.merge(params, %{"user_id" => socket.assigns.current_user.id})

    case Articles.create_article(params) do
      {:ok, %Articles.Article{status: 0}} ->
        socket
        |> put_flash(:info, "Article saved successfully.")
        |> redirect(
          to: ~p"/users/profile/#{socket.assigns.current_user}/draft")
      {:ok, article} ->
        socket
        |> put_flash(:info, "Article created successfully.")
        |> redirect(to: ~p"/articles/show/#{article}")
      {:error, cs} ->
        assign_form(socket, cs)
    end
  end

  defp assign_form(socket, cs) do
    assign(socket, :form, to_form(cs))
  end
end
