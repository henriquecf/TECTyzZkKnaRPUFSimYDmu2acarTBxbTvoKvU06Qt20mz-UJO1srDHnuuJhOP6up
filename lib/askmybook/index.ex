defmodule Askmybook.Index do
  use GenServer

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def add(id, embedding) do
    GenServer.cast(__MODULE__, {:add, id, embedding})
  end

  def search(embedding, k) do
    GenServer.call(__MODULE__, {:search, embedding, k})
  end

  @impl true
  def init(_opts \\ []) do
    index = ExFaiss.Index.new(384, "IDMap,Flat")

    [book | _] = Askmybook.Books.list_books()

    index =
      book.pages
      |> Enum.reduce(index, fn page, index ->
        ExFaiss.Index.add_with_ids(
          index,
          Nx.from_binary(page.embedding, :f32),
          Nx.tensor([page.id])
        )
      end)

    {:ok, index}
  end

  @impl true
  def handle_cast({:add, id, embedding}, index) do
    index = ExFaiss.Index.add_with_ids(index, embedding, id)
    {:noreply, index}
  end

  @impl true
  def handle_call({:search, embedding, num_results}, _from, index) do
    results = ExFaiss.Index.search(index, embedding, num_results)
    {:reply, results, index}
  end
end
