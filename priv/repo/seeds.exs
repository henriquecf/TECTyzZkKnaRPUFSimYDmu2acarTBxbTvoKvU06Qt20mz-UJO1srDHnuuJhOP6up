# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Askmybook.Repo.insert!(%Askmybook.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# Get book and its pages

alias Askmybook.Books

book_path = "priv/repo/modern-css-with-tailwind-second-edition_P1.0.txt"

pages =
  book_path
  |> File.read!()
  |> String.split("\n\n\n")
  |> Enum.map(&String.trim/1)
  |> Enum.with_index(1)
  |> Enum.map(fn {page, index} ->
    embedding = Askmybook.Model.predict(page)
    %{raw_content: page, number: index, embedding: Nx.to_binary(embedding)}
  end)

{:ok, _book} =
  Books.create_book(%{name: "Modern CSS with Tailwind", author: "Adam Wathan", pages: pages})
