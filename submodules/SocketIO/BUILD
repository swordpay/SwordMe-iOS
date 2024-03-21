load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")

swift_library(
    name = "SocketIO",
    module_name = "SocketIO",
    srcs = glob([
        "Sources/*.swift",
        "Sources/**/*.swift",
        "Sources/SocketIO/**/*.swift",

    ]),
    copts = [
        "-warnings-as-errors",
    ],
    deps = [
        "//submodules/Starscream:Starscream",
    ],
    visibility = [
        "//visibility:public",
    ],
)
