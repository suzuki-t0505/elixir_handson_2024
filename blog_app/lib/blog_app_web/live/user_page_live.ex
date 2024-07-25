defmodule BlogAppWeb.UserPageLive do
  use BlogAppWeb, :live_view

  alias BlogApp.Accounts
  alias BlogApp.Articles

  def render(assigns) do
    ~H"""
    <div class="border-2 rounded-lg px-2 py-4">
      <div class="font-bold text-lg"><%= @user.name %></div>
      <div class="text-gray-600 text-sm"><%= @user.email %></div>
      <div class="whitespace-pre-wrap border-b my-2 pb-2"><%= @user.introduction %></div>
      <div>Articles count : <%= @articles_count %></div>
      <div :if={@user.id == @current_user_id}>
        <.link
          href={~p"/users/settings"}
          class="
          bg-gray-200 hover:bg-gray-400 py-1 px-4
          text-center block w-1/5 mt-2 rounded-lg"
        >
          Edit profile
        </.link>
      </div>
    </div>

    <div>
      <div class="flex gap-2 items-center border-b-2 my-2">
        <%
          base_tab_class = ~w(block rounded-t-lg px-2 py-2 text-xl)
          # @live_action = :info
          tab_class = fn
            action when @live_action == action -> ~w(bg-gray-400)
            _action -> ~w(bg-gray-200 hover:bg-gray-400)
          end
        %>
        <.link
          href={~p"/users/profile/#{@user}"}
          class={[base_tab_class, tab_class.(:info)]}
        >
          Articles
        </.link>
        <.link
          href={~p"/users/profile/#{@user}/draft"}
          class={[base_tab_class, tab_class.(:draft)]}
          :if={@user.id == @current_user_id}>
          Draft
        </.link>
      </div>

      <div>
        <%= if length(@articles) > 0 do %>
          <div :for={article <- @articles} class="flex justify-between pb-2 border-b last:border-none cursor-pointer">
            <div :if={@live_action == :info}>
              <.link href={~p"/users/profile/#{article.user_id}"}>
                <%= article.user.name %>
              </.link>
              <.link href={~p"/articles/show/#{article}"}>
                <div><%= article.submit_date %></div>
                <h2><%= article.title %></h2>
              </.link>
            </div>

            <.link href={~p"/articles/#{article}/edit"}
              :if={@live_action == :draft}>
              <div><%= article.title %></div>
              <div class="truncate" :if={article.body}>
                <%= article.body %>
              </div>
            </.link>
            <%= if @live_action in [:info, :draft] do %>
              <div
                phx-click="set_article_id"
                phx-value-article_id={article.id}
                :if={@user.id == @current_user_id}
              >
                ...
              </div>
              <div :if={article.id == @set_article_id}>
                <.link href={~p"/articles/#{article}/edit"}>Edit</.link>
                <span
                  phx-click="delete_article"
                  phx-value-article_id={article.id}
                >
                  Delete
                </span>
              </div>
            <% end %>
          </div>
        <% else %>
          <div>
            <%=
              case @live_action do
                :info -> "No articles"
                :draft -> "No draft articles"
              end
            %>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"user_id" => user_id}, _uri, socket) do
    socket =
      socket
      |> assign(:user, Accounts.get_user!(user_id))
      |> apply_action(socket.assigns.live_action)
      |> assign(:set_article_id, nil)

    {:noreply, socket}
  end

  defp apply_action(socket, :info) do
    user = socket.assigns.user
    current_user = socket.assigns.current_user # => %User{} or nil
    current_user_id = get_current_user_id(current_user)

    articles =
      Articles.list_articles_for_user(user.id, current_user_id)

    socket
    |> assign(:articles, articles)
    |> assign(:articles_count, Enum.count(articles))
    |> assign(:current_user_id, current_user_id)
    |> assign(:page_title, user.name)
  end

  defp apply_action(socket, :draft) do
    user = socket.assigns.user
    current_user = socket.assigns.current_user # => %User{} or nil
    current_user_id = get_current_user_id(current_user)

    if user.id == current_user_id do
      articles_count =
        user.id
        |> Articles.list_articles_for_user(current_user_id)
        |> Enum.count()

      socket
      |> assign(:articles,
        Articles.list_draft_articles_for_user(current_user_id))
      |> assign(:articles_count, articles_count)
      |> assign(:current_user_id, current_user_id)
      |> assign(:page_title, user.name <> "- defat")
    else
      redirect(socket, to: ~p"/users/profile/#{user}")
    end
  end

  def handle_event("set_article_id", %{"article_id" => article_id}, socket) do
    # 開くとき
    # socket.assigns.set_article_id = nil
    # article_id = "1"
    # article_id == "#{socket.assigns.set_article_id}"
    # "1" == nil
    # unless => 1
    # id = 1
    # socket.assigns.set_article_id = 1

    # 閉じとるとき
    # socket.assigns.set_article_id = 1
    # article_id = "1"
    # article_id == "#{socket.assigns.set_article_id}"
    # "1" == "1"
    #  unless => nil
    # id = nil
    # socket.assigns.set_article_id = nil
    id =
      unless article_id == "#{socket.assigns.set_article_id}" do
        String.to_integer(article_id)
      end

    {:noreply, assign(socket, :set_article_id, id)}
  end

  def handle_event("delete_article", %{"article_id" => article_id}, socket) do
    socket =
      case Articles.delete_article(Articles.get_article!(article_id)) do
        {:ok, _article} ->
          assign_article_when_deleted(socket, socket.assigns.live_action)
        {:error, _cs} ->
          put_flash(socket, :error, "Could not article.")
      end

    {:noreply, socket}
  end

  defp assign_article_when_deleted(socket, :info) do
    articles =
      Articles.list_articles_for_user(
        socket.assigns.user.id,
        socket.assigns.current_user.id
      )

    socket
    |> assign(:articles, articles)
    |> assign(:articles_count, Enum.count(articles))
    |> put_flash(:info, "Article deleted successfully.")
  end

  defp assign_article_when_deleted(socket, :draft) do
    socket
    |> assign(:articles,
    Articles.list_draft_articles_for_user(socket.assigns.current_user.id))
    |> put_flash(:info, "Draft article deleted successfully.")
  end

  defp get_current_user_id(current_user) do
    Map.get(current_user || %{}, :id)
  end
end
