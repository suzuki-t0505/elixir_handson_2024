defmodule CounterAppWeb.CounterLive do
  use CounterAppWeb, :live_view

  def render(assigns) do
    ~H"""
    <h1>This is : <%= @value %></h1>
    <.button type="button" phx-click="dec">-</.button>
    <.button type="button" phx-click="inc">+</.button>
    """
  end

  # "/counter"にアクセスがあった場合まずこのmountが呼ばれる
  # mountは必ず定義します。
  # mountは必ず{:ok, socket}を返すようにする
  def mount(_params, _session, socket) do
    # assign(socket, :value, 0) => socketを返す
    {:ok, assign(socket, :value, 0)}
  end

  # phx-clickのイベントを受け取る関数です。
  # 第1引数にイベント名を受け取る
  # handle_eventは必ず{:noreply, socket}を返すようにします。
  def handle_event("dec", _params, socket) do
    socket = update(socket, :value, fn value -> value - 1 end)
    {:noreply, socket}
  end

  def handle_event("inc", _params, socket) do
    socket = update(socket, :value, fn value -> value + 1 end)
    {:noreply, socket}
  end
end
