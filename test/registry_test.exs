defmodule Companion.RegistryTest do
  use ExUnit.Case, async: true

  defmodule Forwarder do
   use GenEvent

   def handle_event(event, parent) do
     send parent, event
     {:ok, parent}
   end
 end

  setup do
    {:ok, sup} = Companion.Bucket.Supervisor.start_link
    {:ok, manager} = GenEvent.start_link
    {:ok, registry} = Companion.Registry.start_link(manager, sup)

    GenEvent.add_mon_handler(manager, Forwarder, self())
    {:ok, registry: registry}
  end

  test "sends events on create and crash", %{registry: registry} do
    Companion.Registry.create(registry, "names")
    {:ok, bucket} = Companion.Registry.lookup(registry, "names")
    assert_receive {:create, "names", ^bucket}

    Agent.stop(bucket)
    assert_receive {:exit, "names", ^bucket}
  end

  test "removes bucket on crash", %{registry: registry} do
     Companion.Registry.create(registry, "names")
     {:ok, bucket} = Companion.Registry.lookup(registry, "names")

     Process.exit(bucket, :shutdown)
     assert_receive {:exit, "names", ^bucket}
     assert Companion.Registry.lookup(registry, "names") == :error
   end

  test "spawn buckets", %{registry: registry} do
    assert Companion.Registry.lookup(registry, "names") == :error
    Companion.Registry.create(registry, "names")
    assert {:ok, bucket} = Companion.Registry.lookup(registry, "names")

    Companion.Bucket.put(bucket, "creator", "Joao")
    assert Companion.Bucket.get(bucket, "creator") == "Joao"
  end

  test "removes buckets on exit", %{registry: registry} do
    Companion.Registry.create(registry, "names")
    {:ok, bucket} = Companion.Registry.lookup(registry, "names")
    Agent.stop(bucket)
    assert Companion.Registry.lookup(registry, "names") == :error
  end
end
