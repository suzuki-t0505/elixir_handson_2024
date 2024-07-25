alias BlogApp.Repo
alias BlogApp.Accounts.User
alias BlogApp.Articles.Article

params = [
  {"user01", "user01@example.com", "user01999"},
  {"user02", "user02@example.com", "user02999"},
  {"user03", "user03@example.com", "user03999"}
]

[u01, u02, _u03] =
  Enum.map(params, fn {name, email, password} ->
    Repo.insert!(
      %User{
        name: name,
        email: email,
        hashed_password: Bcrypt.hash_pwd_salt(password),
        confirmed_at: DateTime.truncate(DateTime.utc_now(), :second)
      }
    )
  end)

Repo.insert!(
  %Article{
    title: "初めての投稿",
    body: """
    初めての投稿です。
    よろしくお願いします。
    """,
    status: 1,
    submit_date: Date.utc_today(),
    user_id: u01.id
  }
)

Repo.insert!(
  %Article{
    title: "#{u02.name}です",
    body: """
    初めまして、#{u02.name}です。
    よろしくお願いします。
    """,
    status: 1,
    submit_date: Date.utc_today(),
    user_id: u02.id
  }
)

Repo.insert!(
  %Article{
    title: "限定記事です",
    body: """
    これは限定記事です。
    URLを知っている人のみ見れます。
    """,
    status: 2,
    submit_date: Date.utc_today(),
    user_id: u01.id
  }
)

Repo.insert!(
  %Article{
    title: "下書き記事です",
    body: """
    これは下書き記事です。
    作成者のみ見れます。
    """,
    status: 0,
    user_id: u01.id
  }
)
