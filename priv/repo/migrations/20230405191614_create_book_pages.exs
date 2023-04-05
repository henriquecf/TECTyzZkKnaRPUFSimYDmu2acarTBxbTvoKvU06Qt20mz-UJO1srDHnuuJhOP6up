defmodule Askmybook.Repo.Migrations.CreateBookPages do
  use Ecto.Migration

  def change do
    create table(:book_pages) do
      add :number, :integer
      add :raw_content, :text
      add :embedding, :binary
      add :book_id, references(:books, on_delete: :nothing)

      timestamps()
    end

    create index(:book_pages, [:book_id])
  end
end
