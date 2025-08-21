defmodule Plot.Users do
  use Ecto.Schema
  alias Plot.Repo
  import Ecto.Changeset

    @type t :: %__MODULE__{}

  schema "users" do
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :password_confirmation, :string, virtual: true
    field :name, :string
    has_many :plots, Plot.Plot, foreign_key: :user_id

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password, :name])
    |> validate_required([:email, :password, :name])
    |> unique_constraint(:email)
    |> validate_length(:password, min: 6)
    |> validate_format(:email, ~r/@/)
    |> put_pass_hash()
    |> validate_confirmation(:password, message: "does not match confirmation")
    |> delete_change(:password)
  end

  def login_changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
  end

    def authenticate_user(email, password) do
      case Repo.get_by(__MODULE__, email: email) do
        nil -> {:error, :not_found}
        user ->
          if Bcrypt.verify_pass(password, user.password_hash) do
            {:ok, Repo.preload(user, :plots)}
          else
            {:error, :unauthorized}
          end
      end
    end


  defp put_pass_hash(changeset) do
    if password = get_change(changeset, :password) do
      put_change(changeset, :password_hash, Bcrypt.hash_pwd_salt(password))
    else
      changeset
    end
  end

end
