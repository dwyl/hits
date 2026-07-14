defmodule Hits.Cron do
  use Quantum, otp_app: :hits
  alias Hits.{Hit, HitCount, Repo}
  import Ecto.Query

  def update_hit_count do
    # SELECT the oldest record in the hit_count table:
    record =  get_oldest_hit_count_record()
    count = Hit.count_hits(record.repo_id)
    IO.inspect("hit_count id:#{record.id} | count:#{count} | repo_id:#{record.repo_id}")
    HitCount.update_hit_count(record, count)
  end

  defp get_oldest_hit_count_record() do
    HitCount
    |> order_by(asc: :inserted_at)
    |> limit(1)
    |> Repo.one!()
  end
end
