defmodule Askmybook.Books.Answer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "books_answers" do
    field :answer, :string
    field :question, :string
    field :book_id, :integer

    timestamps()
  end

  @doc false
  def changeset(answer, attrs) do
    answer
    |> cast(attrs, [:question, :answer, :book_id])
    |> validate_required([:question, :answer, :book_id])
  end
end
