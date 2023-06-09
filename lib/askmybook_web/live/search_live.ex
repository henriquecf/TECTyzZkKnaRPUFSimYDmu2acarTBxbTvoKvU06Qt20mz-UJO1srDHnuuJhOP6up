defmodule AskmybookWeb.SearchLive do
  use AskmybookWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    [book | _] = Askmybook.Books.list_books()

    socket =
      socket
      |> assign(:book, book)
      |> assign(:result, nil)
      |> assign(:page_title, book.name)
      |> assign(:query, "")

    {:ok, socket}
  end

  @impl true
  def handle_event("search_for_books", %{"query" => query}, socket) do
    socket =
      case Askmybook.Books.answer_from_book(socket.assigns.book, query) do
        {:ok, answer} ->
          socket
          |> assign(:result, answer)
          |> assign(:query, "")

        {:error, error} ->
          assign(socket, :result, inspect(error))
      end

    {:noreply, socket}
  end
end
