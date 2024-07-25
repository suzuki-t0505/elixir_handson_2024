defmodule BlogApp.Articles do
  @moduledoc """
  The Articles context.
  """

  import Ecto.Query, warn: false
  alias BlogApp.Repo

  alias BlogApp.Articles.Article

  @doc """
  Returns the list of articles.

  ## Examples

      iex> list_articles()
      [%Article{}, ...]

  """
  def list_articles do
    Article
    |> where([a], a.status == 1)
    |> preload(:user)
    |> Repo.all()
  end

  def list_articles_for_user(user_id, current_user_id)
    when user_id == current_user_id do
    Article
    |> where([a], a.status in [1, 2])
    |> get_articles_for_user_by_query(user_id)
  end

  def list_articles_for_user(user_id, _current_user_id) do
    Article
    |> where([a], a.status == 1)
    |> get_articles_for_user_by_query(user_id)
  end

  def list_draft_articles_for_user(user_id) do
    Article
    |> where([a], a.status == 0)
    |> get_articles_for_user_by_query(user_id)
  end

  def get_articles_for_user_by_query(query, user_id) do
    query
    |> where([a], a.user_id == ^user_id)
    |> preload([:user])
    |> Repo.all()
  end

  @doc """
  Gets a single article.

  Raises `Ecto.NoResultsError` if the Article does not exist.

  ## Examples

      iex> get_article!(123)
      %Article{}

      iex> get_article!(456)
      ** (Ecto.NoResultsError)

  """
  def get_article!(id) do
    Article
    |> where([a], a.id == ^id)
    |> preload(:user)
    |> Repo.one!()
  end

  @doc """
  Creates a article.

  ## Examples

      iex> create_article(%{field: value})
      {:ok, %Article{}}

      iex> create_article(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_article(attrs \\ %{}) do
    %Article{}
    |> Article.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a article.

  ## Examples

      iex> update_article(article, %{field: new_value})
      {:ok, %Article{}}

      iex> update_article(article, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_article(%Article{} = article, attrs) do
    article
    |> Article.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a article.

  ## Examples

      iex> delete_article(article)
      {:ok, %Article{}}

      iex> delete_article(article)
      {:error, %Ecto.Changeset{}}

  """
  def delete_article(%Article{} = article) do
    Repo.delete(article)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking article changes.

  ## Examples

      iex> change_article(article)
      %Ecto.Changeset{data: %Article{}}

  """
  def change_article(%Article{} = article, attrs \\ %{}) do
    Article.changeset(article, attrs)
  end
end
