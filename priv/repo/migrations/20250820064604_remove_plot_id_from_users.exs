defmodule Plot.Repo.Migrations.RemovePlotIdFromUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove :plot_id
    end

    # If you want to drop the foreign key constraint, you can uncomment the line below
    # drop constraint(:users, :plot_id)
  end
end
