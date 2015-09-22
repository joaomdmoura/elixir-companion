defmodule Companion.BucketTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, bucket} = Companion.Bucket.start_link
    {:ok, bucket: bucket}
  end

  test "stores values by key", %{bucket: bucket} do
    assert Companion.Bucket.get(bucket, "milk") == nil

    Companion.Bucket.put(bucket, "milk", 3)
    assert Companion.Bucket.get(bucket, "milk") == 3
  end

  test "delete values by key", %{bucket: bucket} do
    Companion.Bucket.put(bucket, "milk", 3)
    assert Companion.Bucket.get(bucket, "milk") == 3

    Companion.Bucket.delete(bucket, "milk")
    assert Companion.Bucket.get(bucket, "milk") == nil
  end
end
