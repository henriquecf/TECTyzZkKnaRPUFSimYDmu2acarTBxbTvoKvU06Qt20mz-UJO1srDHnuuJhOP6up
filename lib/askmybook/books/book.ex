defmodule Askmybook.Books.Book do
  use Ecto.Schema
  import Ecto.Changeset

  schema "books" do
    field :author, :string
    field :name, :string

    has_many :pages, Askmybook.Books.Page

    timestamps()
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [:name, :author])
    |> validate_required([:name, :author])
    |> cast_assoc(:pages)
  end
end
