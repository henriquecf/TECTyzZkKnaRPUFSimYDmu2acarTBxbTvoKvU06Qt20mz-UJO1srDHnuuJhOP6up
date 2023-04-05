defmodule Askmybook.Books.Page do
  use Ecto.Schema
  import Ecto.Changeset

  schema "book_pages" do
    field :embedding, :binary
    field :number, :integer
    field :raw_content, :string
    field :book_id, :id

    timestamps()
  end

  @doc false
  def changeset(page, attrs) do
    page
    |> cast(attrs, [:number, :raw_content, :embedding])
    |> validate_required([:number, :raw_content, :embedding])
  end
end
