defmodule SmartGit.GithubApi.GetRepos do
  use Tesla

  @middleware [
    {Tesla.Middleware.BaseUrl, "https://api.github.com"},
    Tesla.Middleware.JSON
  ]

  def get_repos(language, page, per_page) do
    @middleware
    |> Tesla.client()
    |> get("/search/repositories",
      query: [
        q: "language:#{language}",
        sort: "stars",
        order: "desc",
        page: page,
        per_page: per_page
      ]
    )
    |> return_value
  end

  def return_value({:ok, %{status: 403}}), do: {:error, "Limite excedido espere mais pouco"}

  def return_value({:ok, %{body: %{"items" => items}}}) do
    items
    |> Enum.map(fn item ->
      %{
        "id" => id,
        "owner" => %{"avatar_url" => avatar_url},
        "full_name" => full_name,
        "watchers_count" => watchers_count,
        "html_url" => url,
        "forks" => forks,
        "description" => description,
        "name" => name,
        "open_issues" => open_issues,
        "language" => language
      } = item

      %{
        git_id: id,
        avatar_url: avatar_url,
        full_name: full_name,
        watchers_count: watchers_count,
        forks: forks,
        url: url,
        description: description,
        name: name,
        open_issues: open_issues,
        language: language
      }
    end)
  end
end
