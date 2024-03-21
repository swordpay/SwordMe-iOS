load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")

swift_library(
    name = "Starscream",
    module_name = "Starscream",
    srcs = glob([
        "Sources/*.swift",
        "Sources/**/*.swift",

    ]),
    copts = [
        "-warnings-as-errors",
    ],
    deps = [
    ],
    visibility = [
        "//visibility:public",
    ],
)
