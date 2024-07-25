defmodule BlogApp.Articles.Article do
  use Ecto.Schema
  import Ecto.Changeset
  alias BlogApp.Accounts.User

  # 0:下書き記事 => "body"検証しない
  # 1:公開記事 => "body"検証する
  # 2:限定公開記事 => "body"検証する

  schema "articles" do
    field :status, :integer, default: 0
    field :title, :string
    field :body, :string
    field :submit_date, :date
    belongs_to(:user, User)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(article, attrs) do
    article
    |> cast(attrs, [:title, :body, :status, :user_id])
    |> validate_article()
  end

  def validate_article(cs) do
    cs = validate_required(cs, :title, message: "Please fill in the title.")

    if get_field(cs, :status, 0) > 0 do
      cs
      |> validate_required(:body, message: "Please fill in the body.")
      |> change(%{submit_date: Date.utc_today()})
      |> validate_required(:submit_date)
    else
      cs
    end
  end
end
