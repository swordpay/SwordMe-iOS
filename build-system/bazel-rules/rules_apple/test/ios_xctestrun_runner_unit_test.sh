#!/bin/bash

# Copyright 2018 The Bazel Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Integration tests for iOS xctestrun runner.

function set_up() {
  mkdir -p ios
}

function tear_down() {
  rm -rf ios
}

function create_sim_runners() {
  cat > ios/BUILD <<EOF
load(
    "@build_bazel_rules_apple//apple:ios.bzl",
    "ios_application",
    "ios_unit_test"
)
load("@build_bazel_rules_swift//swift:swift.bzl",
     "swift_library"
)
load(
    "@build_bazel_rules_apple//apple/testing/default_runner:ios_xctestrun_runner.bzl",
    "ios_xctestrun_runner"
)

ios_xctestrun_runner(
    name = "ios_x86_64_sim_runner",
    device_type = "iPhone Xs",
)

ios_xctestrun_runner(
    name = "ios_x86_64_sim_reuse_disabled_runner",
    device_type = "iPhone Xs",
    reuse_simulator = False,
)

EOF
}

function create_test_host_app() {
  if [[ ! -f ios/BUILD ]]; then
    fail "create_sim_runners must be called first."
  fi

  cat > ios/main.m <<EOF
#import <UIKit/UIKit.h>

int main(int argc, char * argv[]) {
  @autoreleasepool {
    return UIApplicationMain(argc, argv, nil, nil);
  }
}
EOF

  cat > ios/Info.plist <<EOF
{
  CFBundleIdentifier = "\${PRODUCT_BUNDLE_IDENTIFIER}";
  CFBundleName = "\${PRODUCT_NAME}";
  CFBundlePackageType = "APPL";
  CFBundleShortVersionString = "1.0";
  CFBundleVersion = "1.0";
}
EOF

  cat >> ios/BUILD <<EOF
objc_library(
    name = "app_lib",
    srcs = [
        "main.m"
    ],
)

ios_application(
    name = "app",
    bundle_id = "my.bundle.id",
    families = ["iphone"],
    infoplists = ["Info.plist"],
    minimum_os_version = "${MIN_OS_IOS}",
    provisioning_profile = "@build_bazel_rules_apple//test/testdata/provisioning:integration_testing_ios.mobileprovision",
    deps = [":app_lib"],
)
EOF
}

function create_ios_unit_tests() {
  if [[ ! -f ios/BUILD ]]; then
    fail "create_sim_runners must be called first."
  fi

  cat > ios/small_unit_test_1.m <<EOF
#import <XCTest/XCTest.h>
#import <XCTest/XCUIApplication.h>

@interface SmallUnitTest1 : XCTestCase

@end

@implementation SmallUnitTest1
- (void)testPass {
  XCTAssertEqual(1, 1, @"should pass");
}
@end
EOF

  cat > ios/small_unit_test_2.m <<EOF
#import <XCTest/XCTest.h>
#import <XCTest/XCUIApplication.h>

@interface SmallUnitTest2 : XCTestCase

@end

@implementation SmallUnitTest2
- (void)testPass {
  XCTAssertEqual(1, 1, @"should pass");
}
@end
EOF

  cat > ios/pass_unit_test.m <<EOF
#import <XCTest/XCTest.h>
#import <XCTest/XCUIApplication.h>

@interface PassingUnitTest : XCTestCase

@end

@implementation PassingUnitTest {
  XCUIApplication *_app;
}

- (void)testPass {
  XCTAssertEqual(1, 1, @"should pass");
}

- (void)testPass2 {
  XCTAssertEqual(1, 1, @"should pass");
}

- (void)testPass3 {
  XCTAssertEqual(1, 1, @"should pass");
}

- (void)testPassEnvVariable {
  XCTAssertEqualObjects([NSProcessInfo processInfo].environment[@"SomeVariable1"], @"Its My First Variable", @"should pass");
  XCTAssertEqualObjects([NSProcessInfo processInfo].environment[@"SomeVariable2"], @"Its My Second Variable", @"should pass");
  XCTAssertEqualObjects([NSProcessInfo processInfo].environment[@"REFERENCE_DIR"], @"/Project/My Tests/ReferenceImages", @"should pass");
  XCTAssertEqualObjects([NSProcessInfo processInfo].environment[@"IMAGE_DIR"], @"/Project/My Tests/Images", @"should pass");
}

- (void)uiTestSymbols {
  // This function triggers https://github.com/google/xctestrunner/blob/7f8fc81b10c8d93f09f6fe38b2a3f37ba25336a6/test_runner/xctest_session.py#L382
  _app = [[XCUIApplication alloc] init];
}

@end
EOF

  cat > ios/pass_unit_test.swift <<EOF
import XCTest

class PassingUnitTest : XCTestCase {
  func testPass() throws {
    let result = 1 + 1;
    XCTAssertEqual(result, 2, "should pass");
  }

  func testSrcdirSet() {
    XCTAssertNotNil(ProcessInfo.processInfo.environment["TEST_SRCDIR"])
  }

  func testUndeclaredOutputsSet() {
    XCTAssertNotNil(ProcessInfo.processInfo.environment["TEST_UNDECLARED_OUTPUTS_DIR"])
  }
}
EOF

  cat > ios/fail_unit_test.m <<EOF
#import <XCTest/XCTest.h>

@interface FailingUnitTest : XCTestCase

@end

@implementation FailingUnitTest

- (void)testFail {
  XCTAssertEqual(0, 1, @"should fail");
}

@end
EOF

  cat > ios/SmallUnitTest-Info.plist <<EOF
<plist version="1.0">
<dict>
        <key>CFBundleExecutable</key>
        <string>SmallUnitTest</string>
</dict>
</plist>
EOF

  cat > ios/PassUnitTest-Info.plist <<EOF
<plist version="1.0">
<dict>
        <key>CFBundleExecutable</key>
        <string>PassingUnitTest</string>
</dict>
</plist>
EOF

  cat > ios/PassUnitSwiftTest-Info.plist <<EOF
<plist version="1.0">
<dict>
        <key>CFBundleExecutable</key>
        <string>PassUnitSwiftTest</string>
</dict>
</plist>
EOF

  cat > ios/FailUnitTest-Info.plist <<EOF
<plist version="1.0">
<dict>
        <key>CFBundleExecutable</key>
        <string>FailingUnitTest</string>
</dict>
</plist>
EOF

  cat >> ios/BUILD <<EOF
test_env = {
    "SomeVariable1": "Its My First Variable",
    "SomeVariable2": "Its My Second Variable",
    "REFERENCE_DIR": "/Project/My Tests/ReferenceImages",
    "IMAGE_DIR": "/Project/My Tests/Images"
}

objc_library(
    name = "small_unit_test_lib",
    srcs = ["small_unit_test_1.m", "small_unit_test_2.m"],
)

ios_unit_test(
    name = "SmallUnitTest",
    infoplists = ["SmallUnitTest-Info.plist"],
    deps = [":small_unit_test_lib"],
    minimum_os_version = "${MIN_OS_IOS}",
    env = test_env,
    runner = ":ios_x86_64_sim_runner",
)

objc_library(
    name = "pass_unit_test_lib",
    srcs = ["pass_unit_test.m"],
)

ios_unit_test(
    name = "PassingUnitTest",
    infoplists = ["PassUnitTest-Info.plist"],
    deps = [":pass_unit_test_lib"],
    minimum_os_version = "${MIN_OS_IOS}",
    env = test_env,
    runner = ":ios_x86_64_sim_runner",
)

ios_unit_test(
    name = "PassingWithHost",
    infoplists = ["PassUnitTest-Info.plist"],
    deps = [":pass_unit_test_lib"],
    minimum_os_version = "${MIN_OS_IOS}",
    test_host = ":app",
    env = test_env,
    runner = ":ios_x86_64_sim_runner",
)

ios_unit_test(
    name = "PassingWithHostSimReuseDisabled",
    infoplists = ["PassUnitTest-Info.plist"],
    deps = [":pass_unit_test_lib"],
    minimum_os_version = "${MIN_OS_IOS}",
    test_host = ":app",
    env = test_env,
    runner = ":ios_x86_64_sim_reuse_disabled_runner",
)

swift_library(
    name = "pass_unit_swift_test_lib",
    testonly = True,
    srcs = ["pass_unit_test.swift"],
)

ios_unit_test(
    name = "PassingUnitSwiftTest",
    infoplists = ["PassUnitSwiftTest-Info.plist"],
    deps = [":pass_unit_swift_test_lib"],
    minimum_os_version = "${MIN_OS_IOS}",
    test_host = ":app",
    runner = ":ios_x86_64_sim_runner",
)

objc_library(
    name = "fail_unit_test_lib",
    srcs = ["fail_unit_test.m"],
)

ios_unit_test(
    name = 'FailingUnitTest',
    infoplists = ["FailUnitTest-Info.plist"],
    deps = [":fail_unit_test_lib"],
    minimum_os_version = "${MIN_OS_IOS}",
    runner = ":ios_x86_64_sim_runner",
)

ios_unit_test(
    name = 'FailingWithHost',
    infoplists = ["FailUnitTest-Info.plist"],
    deps = [":fail_unit_test_lib"],
    minimum_os_version = "${MIN_OS_IOS}",
    test_host = ":app",
    runner = ":ios_x86_64_sim_runner",
)
EOF
}

function create_ios_unit_envtest() {
  if [[ ! -f ios/BUILD ]]; then
    fail "create_sim_runners must be called first."
  fi

  cat > ios/env_unit_test.m <<EOF
#import <XCTest/XCTest.h>
#include <assert.h>
#include <stdlib.h>

@interface EnvUnitTest : XCTestCase

@end

@implementation EnvUnitTest

- (void)testEnv {
  NSString *var_value = [[[NSProcessInfo processInfo] environment] objectForKey:@"$1"];
  XCTAssertEqualObjects(var_value, @"$2", @"env $1 should be %@, instead is %@", @"$2", var_value);
}

@end
EOF

  cat >ios/EnvUnitTest-Info.plist <<EOF
<plist version="1.0">
<dict>
        <key>CFBundleExecutable</key>
        <string>EnvUnitTest</string>
</dict>
</plist>
EOF

  cat >> ios/BUILD <<EOF
objc_library(
    name = "env_unit_test_lib",
    srcs = ["env_unit_test.m"],
)

ios_unit_test(
    name = 'EnvUnitTest',
    infoplists = ["EnvUnitTest-Info.plist"],
    deps = [":env_unit_test_lib"],
    minimum_os_version = "${MIN_OS_IOS}",
    runner = ":ios_x86_64_sim_runner",
)

ios_unit_test(
    name = 'EnvWithHost',
    infoplists = ["EnvUnitTest-Info.plist"],
    deps = [":env_unit_test_lib"],
    minimum_os_version = "${MIN_OS_IOS}",
    test_host = ":app",
    runner = ":ios_x86_64_sim_runner",
)
EOF
}

function create_ios_unit_argtest() {
  if [[ ! -f ios/BUILD ]]; then
    fail "create_sim_runners must be called first."
  fi

  cat > ios/arg_unit_test.m <<EOF
#import <XCTest/XCTest.h>
#include <assert.h>
#include <stdlib.h>

@interface ArgUnitTest : XCTestCase

@end

@implementation ArgUnitTest

- (void)testArg {
  XCTAssertTrue([[NSProcessInfo processInfo].arguments containsObject: @"--flag"], @"should pass");
  XCTAssertTrue([[NSProcessInfo processInfo].arguments containsObject: @"First"], @"should pass");
  XCTAssertTrue([[NSProcessInfo processInfo].arguments containsObject: @"Second"], @"should pass");
$([ $# != 0 ] && printf "  XCTAssertTrue([[NSProcessInfo processInfo].arguments containsObject: @\"%s\"], @\"should pass\");\n" "$@")
}

@end
EOF

  cat >ios/ArgUnitTest-Info.plist <<EOF
<plist version="1.0">
<dict>
        <key>CFBundleExecutable</key>
        <string>ArgUnitTest</string>
</dict>
</plist>
EOF

  cat >> ios/BUILD <<EOF
objc_library(
    name = "arg_unit_test_lib",
    srcs = ["arg_unit_test.m"],
)

ios_unit_test(
    name = 'ArgUnitTest',
    infoplists = ["ArgUnitTest-Info.plist"],
    deps = [":arg_unit_test_lib"],
    minimum_os_version = "${MIN_OS_IOS}",
    runner = ":ios_x86_64_sim_runner",
    args = [
      "--command_line_args=--flag",
      "--command_line_args=First,Second",
    ],
)
EOF
}

function create_ios_unit_tests_test_filter() {
  if [[ ! -f ios/BUILD ]]; then
    fail "create_sim_runners must be called first."
  fi

  cat > ios/test_filter_unit_test.m <<EOF
#import <XCTest/XCTest.h>
#import <XCTest/XCUIApplication.h>

@interface TestFilterUnitTest : XCTestCase

@end

@implementation TestFilterUnitTest {
  XCUIApplication *_app;
}

- (void)testPass {
  XCTAssertEqual(1, 1, @"should pass");
}

- (void)testPass2 {
  XCTAssertEqual(1, 1, @"should pass");
}

- (void)testPass3 {
  XCTAssertEqual(1, 1, @"should pass");
}

@end
EOF

  cat > ios/TestFilterUnitTest-Info.plist <<EOF
<plist version="1.0">
<dict>
        <key>CFBundleExecutable</key>
        <string>TestFilterUnitTest</string>
</dict>
</plist>
EOF

  cat >> ios/BUILD <<EOF
objc_library(
    name = "test_filter_unit_test_lib",
    srcs = ["test_filter_unit_test.m"],
)

ios_unit_test(
    name = "TestFilterUnitTest",
    infoplists = ["TestFilterUnitTest-Info.plist"],
    deps = [":test_filter_unit_test_lib"],
    minimum_os_version = "${MIN_OS_IOS}",
    test_host = ":app",
    runner = ":ios_x86_64_sim_runner",
    test_filter = "$1",
)
EOF
}

function do_ios_test() {
  do_test ios "--test_output=all" "--spawn_strategy=local" "$@"
}

function test_ios_unit_test_small_pass() {
  create_sim_runners
  create_ios_unit_tests
  do_ios_test //ios:SmallUnitTest || fail "should pass"

  expect_log "Test Suite 'SmallUnitTest1' passed"
  expect_log "Test Suite 'SmallUnitTest2' passed"
  expect_log "Test Suite 'SmallUnitTest.xctest' passed"
  expect_log "Executed 2 tests, with 0 failures"
}

# Test bundle has tests with one test class with all tests filtered.
function test_ios_unit_test_small_empty_test_class_filter_pass() {
  create_sim_runners
  create_ios_unit_tests
  do_ios_test --test_filter="-SmallUnitTest1/testPass" //ios:SmallUnitTest || fail "should pass"

  expect_log "Test Suite 'SmallUnitTest1' passed"
  expect_log "Test Suite 'SmallUnitTest2' passed"
  expect_log "Test Suite 'SmallUnitTest.xctest' passed"
  expect_log "Executed 1 test, with 0 failures"
}

# Test bundle has tests but filter excludes all of them.
function test_ios_unit_test_small_empty_fail() {
  create_sim_runners
  create_ios_unit_tests

  ! do_ios_test --test_filter="BadFilter" //ios:SmallUnitTest || fail "should fail"

  expect_log "Test Suite 'SmallUnitTest.xctest' passed"
  expect_log "Executed 0 tests, with 0 failures"
}

function test_ios_unit_test_pass() {
  create_sim_runners
  create_ios_unit_tests
  do_ios_test //ios:PassingUnitTest || fail "should pass"

  expect_log "Test Suite 'PassingUnitTest' passed"
  expect_log "Test Suite 'PassingUnitTest.xctest' passed"
  expect_log "Executed 4 tests, with 0 failures"
}

function test_ios_unit_test_with_host_pass() {
  create_sim_runners
  create_test_host_app
  create_ios_unit_tests
  do_ios_test //ios:PassingWithHost || fail "should pass"

  expect_log "Test Suite 'PassingUnitTest' passed"
  expect_log "Test Suite 'PassingWithHost.xctest' passed"
  expect_log "Executed 4 tests, with 0 failures"
}

function test_ios_unit_test_with_host_sim_reuse_disabled_pass() {
  create_sim_runners
  create_test_host_app
  create_ios_unit_tests
  do_ios_test //ios:PassingWithHostSimReuseDisabled || fail "should pass"

  expect_log "Test Suite 'PassingUnitTest' passed"
  expect_log "Test Suite 'PassingWithHostSimReuseDisabled.xctest' passed"
  expect_log "Executed 4 tests, with 0 failures"
}

function test_ios_unit_swift_test_pass() {
  create_sim_runners
  create_test_host_app
  create_ios_unit_tests
  do_ios_test //ios:PassingUnitSwiftTest || fail "should pass"

  expect_log "Test Suite 'PassingUnitTest' passed"
  expect_log "Test Suite 'PassingUnitSwiftTest.xctest' passed"
  expect_log "Executed 3 tests, with 0 failures"
}

function test_ios_unit_test_fail() {
  create_sim_runners
  create_ios_unit_tests
  ! do_ios_test //ios:FailingUnitTest || fail "should fail"

  expect_log "Test Suite 'FailingUnitTest' failed"
  expect_log "Test Suite 'FailingUnitTest.xctest' failed"
  expect_log "Executed 1 test, with 1 failure"
}

function test_ios_unit_test_with_host_fail() {
  create_sim_runners
  create_test_host_app
  create_ios_unit_tests
  ! do_ios_test //ios:FailingWithHost || fail "should fail"

  expect_log "Test Suite 'FailingUnitTest' failed"
  expect_log "Test Suite 'FailingWithHost.xctest' failed"
  expect_log "Executed 1 test, with 1 failure"
}

function test_ios_unit_test_with_filter() {
  create_sim_runners
  create_ios_unit_tests
  do_ios_test --test_filter=PassingUnitTest/testPass2 //ios:PassingUnitTest || fail "should pass"

  expect_log "Test Case '-\[PassingUnitTest testPass2\]' passed"
  expect_log "Test Suite 'PassingUnitTest' passed"
  expect_log "Test Suite 'PassingUnitTest.xctest' passed"
  expect_log "Executed 1 test, with 0 failures"
}

function test_ios_unit_test_with_multi_filter() {
  create_sim_runners
  create_ios_unit_tests
  do_ios_test --test_filter=PassingUnitTest/testPass2,PassingUnitTest/testPass3 //ios:PassingUnitTest || fail "should pass"

  expect_log "Test Case '-\[PassingUnitTest testPass2\]' passed"
  expect_log "Test Case '-\[PassingUnitTest testPass3\]' passed"
  expect_log "Test Suite 'PassingUnitTest' passed"
  expect_log "Test Suite 'PassingUnitTest.xctest' passed"
  expect_log "Executed 2 tests, with 0 failures"
}

function test_ios_unit_test_with_host_with_filter() {
  create_sim_runners
  create_test_host_app
  create_ios_unit_tests
  do_ios_test --test_filter=PassingUnitTest/testPass2 //ios:PassingWithHost || fail "should pass"

  expect_log "Test Case '-\[PassingUnitTest testPass2\]' passed"
  expect_log "Test Suite 'PassingUnitTest' passed"
  expect_log "Test Suite 'PassingWithHost.xctest' passed"
  expect_log "Executed 1 test, with 0 failures"
}

function test_ios_unit_test_with_host_and_skip_filter() {
  create_sim_runners
  create_test_host_app
  create_ios_unit_tests
  do_ios_test --test_filter=-PassingUnitTest/testPass //ios:PassingWithHost || fail "should pass"

  expect_not_log "Test Case '-\[PassingUnitTest testPass\]' passed"
  expect_log "Test Case '-\[PassingUnitTest testPass2\]' passed"
  expect_log "Test Case '-\[PassingUnitTest testPass3\]' passed"
  expect_log "Test Suite 'PassingUnitTest' passed"
  expect_log "Test Suite 'PassingWithHost.xctest' passed"
  expect_log "Executed 3 tests, with 0 failures"
}

function test_ios_unit_test_with_host_and_multi_skip_filter() {
  create_sim_runners
  create_test_host_app
  create_ios_unit_tests
  do_ios_test --test_filter=-PassingUnitTest/testPass,-PassingUnitTest/testPass2 //ios:PassingWithHost || fail "should pass"

  expect_not_log "Test Case '-\[PassingUnitTest testPass\]' passed"
  expect_not_log "Test Case '-\[PassingUnitTest testPass2\]' passed"
  expect_log "Test Case '-\[PassingUnitTest testPass3\]' passed"
  expect_log "Test Suite 'PassingUnitTest' passed"
  expect_log "Test Suite 'PassingWithHost.xctest' passed"
  expect_log "Executed 2 tests, with 0 failures"
}

function test_ios_unit_test_with_host_and_skip_and_only_filters() {
  create_sim_runners
  create_test_host_app
  create_ios_unit_tests
  do_ios_test --test_filter=PassingUnitTest,-PassingUnitTest/testPass2 //ios:PassingWithHost || fail "should pass"

  expect_log "Test Case '-\[PassingUnitTest testPass\]' passed"
  expect_not_log "Test Case '-\[PassingUnitTest testPass2\]' passed"
  expect_log "Test Case '-\[PassingUnitTest testPass3\]' passed"
  expect_log "Test Suite 'PassingUnitTest' passed"
  expect_log "Test Suite 'PassingWithHost.xctest' passed"
  expect_log "Executed 3 tests, with 0 failures"
}

function test_ios_unit_test_with_env() {
  create_sim_runners
  create_ios_unit_envtest ENV_KEY1 ENV_VALUE2
  do_ios_test --test_env=ENV_KEY1=ENV_VALUE2 //ios:EnvUnitTest || fail "should pass"

  expect_log "Test Suite 'EnvUnitTest' passed"
}

function test_ios_unit_test_with_host_with_env() {
  create_sim_runners
  create_test_host_app
  create_ios_unit_envtest ENV_KEY1 ENV_VALUE2
  do_ios_test --test_env=ENV_KEY1=ENV_VALUE2 //ios:EnvWithHost || fail "should pass"

  expect_log "Test Suite 'EnvUnitTest' passed"
}

function test_ios_unit_test_dot_separated_command_line_args() {
  create_sim_runners
  create_ios_unit_argtest arg1 arg2 arg3
  do_ios_test //ios:ArgUnitTest \
    --test_arg="--command_line_args=arg1,arg2,arg3" || fail "should pass"

  expect_log "Test Suite 'ArgUnitTest' passed"
}

function test_ios_unit_test_multiple_command_line_args() {
  create_sim_runners
  create_ios_unit_argtest arg1 arg2
  do_ios_test //ios:ArgUnitTest \
    --test_arg="--command_line_args=arg1" \
    --test_arg="--command_line_args=arg2" || fail "should pass"

  expect_log "Test Suite 'ArgUnitTest' passed"
}

function test_ios_unit_other_arg() {
  create_sim_runners
  create_ios_unit_tests
  ! do_ios_test //ios:PassingUnitTest --test_arg=invalid_arg || fail "should fail"

  expect_log "error: Unsupported argument 'invalid_arg'"
}

function test_ios_unit_test_with_multi_equal_env() {
  create_sim_runners
  create_ios_unit_envtest ENV_KEY1 ENV_VALUE2=ENV_VALUE3
  do_ios_test --test_env=ENV_KEY1=ENV_VALUE2=ENV_VALUE3 //ios:EnvUnitTest || fail "should pass"

  expect_log "Test Suite 'EnvUnitTest' passed"
}

function test_ios_unit_test_pass_asan() {
  create_sim_runners
  create_ios_unit_tests
  do_ios_test --features=asan //ios:PassingUnitTest || fail "should pass"

  expect_log "Test Suite 'PassingUnitTest' passed"
  expect_log "Test Suite 'PassingUnitTest.xctest' passed"
  expect_log "Executed 4 tests, with 0 failures"
}

function test_with_test_filter_build_attribute() {
  create_sim_runners
  create_test_host_app
  create_ios_unit_tests_test_filter TestFilterUnitTest/testPass2
  do_ios_test //ios:TestFilterUnitTest || fail "should pass"

  expect_log "Test Case '-\[TestFilterUnitTest testPass2\]' passed"
  expect_log "Test Suite 'TestFilterUnitTest' passed"
  expect_log "Test Suite 'TestFilterUnitTest.xctest' passed"
  expect_log "Executed 1 test, with 0 failures"
}

function test_ios_unit_test_with_multi_test_filter_build_attribute() {
  create_sim_runners
  create_test_host_app
  create_ios_unit_tests_test_filter TestFilterUnitTest/testPass2,TestFilterUnitTest/testPass3
  do_ios_test //ios:TestFilterUnitTest || fail "should pass"

  expect_log "Test Case '-\[TestFilterUnitTest testPass2\]' passed"
  expect_log "Test Case '-\[TestFilterUnitTest testPass3\]' passed"
  expect_log "Test Suite 'TestFilterUnitTest' passed"
  expect_log "Test Suite 'TestFilterUnitTest.xctest' passed"
  expect_log "Executed 2 tests, with 0 failures"
}

function test_ios_unit_test_with_skip_test_filter_build_attribute() {
  create_sim_runners
  create_test_host_app
  create_ios_unit_tests_test_filter -TestFilterUnitTest/testPass
  do_ios_test //ios:TestFilterUnitTest || fail "should pass"

  expect_not_log "Test Case '-\[TestFilterUnitTest testPass\]' passed"
  expect_log "Test Case '-\[TestFilterUnitTest testPass2\]' passed"
  expect_log "Test Case '-\[TestFilterUnitTest testPass3\]' passed"
  expect_log "Test Suite 'TestFilterUnitTest' passed"
  expect_log "Test Suite 'TestFilterUnitTest.xctest' passed"
  expect_log "Executed 2 tests, with 0 failures"
}

function test_ios_unit_test_multi_skip_test_filter_build_attribute() {
  create_sim_runners
  create_test_host_app
  create_ios_unit_tests_test_filter -TestFilterUnitTest/testPass,-TestFilterUnitTest/testPass2
  do_ios_test //ios:TestFilterUnitTest || fail "should pass"

  expect_not_log "Test Case '-\[TestFilterUnitTest testPass\]' passed"
  expect_not_log "Test Case '-\[TestFilterUnitTest testPass2\]' passed"
  expect_log "Test Case '-\[TestFilterUnitTest testPass3\]' passed"
  expect_log "Test Suite 'TestFilterUnitTest' passed"
  expect_log "Test Suite 'TestFilterUnitTest.xctest' passed"
  expect_log "Executed 1 test, with 0 failures"
}

function test_ios_unit_test_with_skip_and_only_filters_build_attribute() {
  create_sim_runners
  create_test_host_app
  create_ios_unit_tests_test_filter TestFilterUnitTest,-TestFilterUnitTest/testPass2
  do_ios_test //ios:TestFilterUnitTest || fail "should pass"

  expect_log "Test Case '-\[TestFilterUnitTest testPass\]' passed"
  expect_not_log "Test Case '-\[TestFilterUnitTest testPass2\]' passed"
  expect_log "Test Case '-\[TestFilterUnitTest testPass3\]' passed"
  expect_log "Test Suite 'TestFilterUnitTest' passed"
  expect_log "Test Suite 'TestFilterUnitTest.xctest' passed"
  expect_log "Executed 2 tests, with 0 failures"
}

function test_ios_unit_test_with_build_attribute_and_test_env_filters() {
  create_sim_runners
  create_test_host_app
  create_ios_unit_tests_test_filter TestFilterUnitTest/testPass2
  do_ios_test --test_filter=TestFilterUnitTest/testPass3 //ios:TestFilterUnitTest || fail "should pass"

  expect_not_log "Test Case '-\[PassingUnitTest testPass\]' passed"
  expect_log "Test Case '-\[TestFilterUnitTest testPass2\]' passed"
  expect_log "Test Case '-\[TestFilterUnitTest testPass3\]' passed"
  expect_log "Test Suite 'TestFilterUnitTest' passed"
  expect_log "Test Suite 'TestFilterUnitTest.xctest' passed"
  expect_log "Executed 2 tests, with 0 failures"
}

# Tests a test execution with parallel testing enabled is successful.
function test_ios_unit_test_parallel_testing_pass() {
  create_sim_runners
  create_ios_unit_tests
  do_ios_test \
    --test_arg=--xcodebuild_args=-parallel-testing-enabled \
    --test_arg=--xcodebuild_args=YES \
    --test_arg=--xcodebuild_args=-parallel-testing-worker-count \
    --test_arg=--xcodebuild_args=1 \
    //ios:SmallUnitTest || fail "should pass"

  expect_log "Test case '-\[SmallUnitTest1 testPass\]' passed"
  expect_log "Test case '-\[SmallUnitTest2 testPass\]' passed"
  expect_log "@@\?//ios:SmallUnitTest\s\+PASSED"
  expect_log "Executed 1 out of 1 test: 1 test passes."
}

# Tests a test execution with parallel testing enabled is failed when
# a test filter leads to no tests being run.
function test_ios_unit_test_parallel_testing_no_tests_fail() {
  create_sim_runners
  create_ios_unit_tests
  ! do_ios_test --test_arg=--xcodebuild_args=-parallel-testing-enabled \
    --test_arg=--xcodebuild_args=YES \
    --test_arg=--xcodebuild_args=-parallel-testing-worker-count \
    --test_arg=--xcodebuild_args=1 \
    --test_filter="BadFilter" \
    //ios:SmallUnitTest || fail "should fail"

  expect_not_log "Test suite 'SmallUnitTest1' started"
  expect_not_log "Test suite 'SmallUnitTest2' started"
  expect_log "@@\?//ios:SmallUnitTest\s\+FAILED"
  expect_log "Executed 1 out of 1 test: 1 fails locally."
}

run_suite "ios_unit_test with iOS xctestrun runner bundling tests"
