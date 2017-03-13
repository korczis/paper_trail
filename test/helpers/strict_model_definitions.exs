defmodule StrictCompany do
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  schema "strict_companies" do
    field :name, :string
    field :is_active, :boolean
    field :website, :string
    field :city, :string
    field :address, :string
    field :facebook, :string
    field :twitter, :string
    field :founded_in, :string

    belongs_to :first_version, PaperTrail.Version
    belongs_to :current_version, PaperTrail.Version, on_replace: :update

    has_many :people, StrictPerson, foreign_key: :company_id

    timestamps()
  end

  @optional_fields ~w(name is_active website city address facebook twitter founded_in)

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @optional_fields)
  end

  def count do
    from(record in __MODULE__, select: count(record.id)) |> PaperTrail.RepoClient.repo.all
  end
end

defmodule StrictPerson do
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  schema "strict_people" do
    field :first_name, :string
    field :last_name, :string
    field :visit_count, :integer
    field :gender, :boolean
    field :birthdate, Ecto.Date

    belongs_to :first_version, PaperTrail.Version
    belongs_to :current_version, PaperTrail.Version, on_replace: :update
    belongs_to :company, StrictCompany, foreign_key: :company_id

    timestamps()
  end

  @optional_fields ~w(first_name last_name visit_count gender birthdate company_id)

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @optional_fields)
    |> foreign_key_constraint(:company_id)
  end

  def count do
    from(record in __MODULE__, select: count(record.id)) |> PaperTrail.RepoClient.repo.all
  end
end
