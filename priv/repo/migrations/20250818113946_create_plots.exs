defmodule Plot.Repo.Migrations.CreatePlots do
  use Ecto.Migration

  def change do
    create table(:plots)do
      add :title, :string, null: false
      add :description, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

  end
end
