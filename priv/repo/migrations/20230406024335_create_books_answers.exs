defmodule Askmybook.Repo.Migrations.CreateBooksAnswers do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext;"

    create table(:books_answers) do
      add :question, :citext
      add :answer, :text
      add :book_id, references(:books, on_delete: :nothing)

      timestamps()
    end

    create index(:books_answers, [:book_id])
    create unique_index(:books_answers, [:book_id, :question])
  end
end
