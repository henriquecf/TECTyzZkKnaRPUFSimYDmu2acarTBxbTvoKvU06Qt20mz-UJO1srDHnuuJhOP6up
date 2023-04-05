defmodule Askmybook.Books do
  @moduledoc """
  The Books context.
  """

  import Ecto.Query, warn: false
  alias Askmybook.Repo

  alias Askmybook.Books.Book

  @doc """
  Returns the list of books.

  ## Examples

      iex> list_books()
      [%Book{}, ...]

  """
  def list_books do
    Repo.all(Book)
    |> Repo.preload(:pages)
  end

  @doc """
  Gets a single book.

  Raises `Ecto.NoResultsError` if the Book does not exist.

  ## Examples

      iex> get_book!(123)
      %Book{}

      iex> get_book!(456)
      ** (Ecto.NoResultsError)

  """
  def get_book!(id) do
    Repo.get!(Book, id)
    |> Repo.preload(:pages)
  end

  @doc """
  Creates a book.

  ## Examples

      iex> create_book(%{field: value})
      {:ok, %Book{}}

      iex> create_book(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_book(attrs \\ %{}) do
    %Book{}
    |> Book.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a book.

  ## Examples

      iex> update_book(book, %{field: new_value})
      {:ok, %Book{}}

      iex> update_book(book, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_book(%Book{} = book, attrs) do
    book
    |> Book.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a book.

  ## Examples

      iex> delete_book(book)
      {:ok, %Book{}}

      iex> delete_book(book)
      {:error, %Ecto.Changeset{}}

  """
  def delete_book(%Book{} = book) do
    Repo.delete(book)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking book changes.

  ## Examples

      iex> change_book(book)
      %Ecto.Changeset{data: %Book{}}

  """
  def change_book(%Book{} = book, attrs \\ %{}) do
    Book.changeset(book, attrs)
  end

  @doc """
  Given a question, we should send a context to allow Chat-GPT to answer it.

  The context is a list of pages from the book that are relevant to the question.

  The relevance is calculated using the embedding of the question and the embedding of the pages.
  """
  def answer_from_book(book, query) do
    prompt = """
    #{book.author} is the author of #{book.name}.

    Answer the following question: #{query}

    I will provide you with the following pages from the book #{book.name} to help with your answer:

    #{relevant_pages(book, query) |> Enum.map(& &1.raw_content) |> Enum.join("\n\n")}
    """

    case OpenAI.chat_completion(
           model: "gpt-3.5-turbo",
           messages: [
             %{role: "user", content: prompt}
           ]
         ) do
      {:ok, %{choices: [%{"message" => %{"content" => content}}]}} -> {:ok, content}
      {:error, _} = error -> error
    end
  end

  def relevant_pages(book, query) do
    embedding = Askmybook.Model.predict(query)
    %{labels: labels} = Askmybook.Index.search(embedding, 5)

    ids = Nx.to_flat_list(labels)

    Enum.filter(book.pages, fn page -> page.id in ids end)
  end
end
