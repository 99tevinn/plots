defmodule Plot.Plot do
  use Ecto.Schema
  import Ecto.Changeset

  schema "plots" do
    field :title, :string
    field :description, :string

    belongs_to :user, Plot.Users

    timestamps()

    @doc false
    def changeset(plot, attrs) do
      plot
      |> cast(attrs, [:title, :description, :user_id])
      |> validate_required([:title, :description, :user_id])
      |> foreign_key_constraint(:user_id)
    end
  end
end
