defmodule Askmybook.Repo.Migrations.CreateBooks do
  use Ecto.Migration

  def change do
    create table(:books) do
      add :name, :string
      add :author, :string

      timestamps()
    end

    create unique_index(:books, [:name])
  end
end
