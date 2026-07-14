defmodule HitCronTest do
  use ExUnit.Case, async: true
  use HitsWeb.ConnCase
  alias Hits.{Hit, HitCount, User, Repository}

  # setup do
  #   # Explicitly get a connection before each test
  #   :ok = Ecto.Adapters.SQL.Sandbox.checkout(Hits.Repo)
  # end

  test "Cron.update_hit_count /ana/best.svg", %{conn: conn} do
    user = User.insert(%{"name" => "alex"})
    repo = Ecto.build_assoc(user, :repositories)
    attrs = %{"name" => "totes-amaze"}

    repository = Repository.insert(repo, attrs)
    assert repository.id > 0

    conn = put_req_header(conn, "user-agent", "Hackintosh")
      |> put_req_header("accept-language", "en-GB,en;q=0.5")

    {_user_schema, _ua_schema, repo} =
      HitsWeb.HitController.insert_hit(conn, user.name, "#{repository.name}.svg")

    assert Hit.count_hits(repo.id) == 1

    {_user_schema, _ua_schema, repo2} =
      HitsWeb.HitController.insert_hit(conn, user.name, "#{repository.name}.svg")

    assert Hit.count_hits(repo2.id) == 2

    assert HitCount.insert_hit_count(repo.id) == 1

    {:ok, hit_count} = Hits.Cron.update_hit_count()
    assert hit_count.count == 2
  end
end
