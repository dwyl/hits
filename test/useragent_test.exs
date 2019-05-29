defmodule UseragentTest do
  use ExUnit.Case
  alias Hits.Useragent

  setup do
    # Explicitly get a connection before each test
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Hits.Repo)
  end

  test "Useragent.insert" do
    useragent = "Mozilla/5.0 (Windows; Windows NT 5.0; rv:1.1) Gecko/20020826"
    ip = "127.0.0.1"
    attrs = %Useragent{name: useragent, ip: ip}
    useragent_id = Useragent.insert(attrs)
    assert useragent_id > 0

    # attempting to insert the same useragent will simply return the same id:
    agent_id_2 = Useragent.insert(attrs)
    assert useragent_id == agent_id_2
  end
end
