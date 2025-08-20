defmodule Plot.Repo.Migrations.update do
  use Ecto.Migration

  def change do
    alter table(:users) do
      # add :email, :string, null: false
      add :password_hash1, :string
      # add :name, :string, null: false
      add :plot_id, :integer, null: true

      timestamps()
    end

    # create unique_index(:users, [:email])
  end
end
