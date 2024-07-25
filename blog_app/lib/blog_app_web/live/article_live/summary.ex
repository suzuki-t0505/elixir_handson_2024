defmodule BlogAppWeb.ArticleLive.Summary do
  use BlogAppWeb, :live_view

  alias BlogApp.Articles

  def render(assigns) do
    ~H"""
    <.header>
      Listing Articles
    </.header>

    <div :for={article <- @articles}
      class="mt-2 border-2 rounded-lg py-2 px-4 cursor-pointer">
      <.link href={~p"/users/profile/#{article.user}"}>
        <%= article.user.name %>
      </.link>
      <.link href={~p"/articles/show/#{article}"}>
        <div class="text-xs text-gray-600"><%= article.submit_date %></div>
        <h2 class="my-2 font-bold text-2xl hover:underline">
          <%= article.title %>
        </h2>
      </.link>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:articles, Articles.list_articles())
      |> assign(:page_title, "blog")

    {:ok, socket}
  end
end
