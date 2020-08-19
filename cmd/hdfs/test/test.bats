#!/usr/bin/env bats

load helper

setup() {
  $HDFS mkdir -p /_test_cmd/test/dir1
  $HDFS mkdir -p /_test_cmd/test/dir2
  $HDFS touch /_test_cmd/test/dir1/a
}

@test "test" {
  run $HDFS test
  assert_success
}

@test "test /" {
  run $HDFS test /
  assert_success
}

@test "test /_test_cmd/test/" {
  run $HDFS test /_test_cmd/test/
  assert_success
}

@test "test nonexisting" {
  run $HDFS test /_test_cmd/test/dir0
  assert_success
}

@test "test -e nonexisting" {
  run $HDFS test -e /_test_cmd/test/dir0
  assert_failure
}

@test "test -e existing dir" {
  run $HDFS test -e /_test_cmd/test/dir1
  assert_success
}

@test "test -e existing file" {
  run $HDFS test -e /_test_cmd/test/dir1/a
  assert_success
}

@test "test -d existing file" {
  run $HDFS test -d /_test_cmd/test/dir1/a
  assert_failure
}

@test "test -d existing dir" {
  run $HDFS test -d /_test_cmd/test/dir1
  assert_success
}

@test "test -r /" {
    run $HDFS test -r /
    assert_success
}

@test "test -r nonexisting" {
    run $HDFS test -r /_test_cmd/test/dir0
    assert_failure
}

@test "test -r existing file" {
    run $HDFS test -r /_test_cmd/test/dir1/a
    assert_success
}

@test "test -r existing dir" {
    run $HDFS test -r /_test_cmd/test/dir1/
    assert_success
}

@test "test -s nonexisting" {
    run $HDFS test -s /_test_cmd/test/dir0
    assert_failure
}

@test "test -s existing empty file" {
    run $HDFS test -s /_test_cmd/test/dir1/a
    assert_failure
}

@test "test -s existing nonempty file" {
    run $HDFS test -s /_test/foo.txt
    assert_success
}

@test "test -s existing directory" {
    run $HDFS test -s /_test_cmd/test/dir1
    assert_success
}

teardown() {
  $HDFS rm -r /_test_cmd/test
}
