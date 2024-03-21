load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")

swift_library(
    name = "GoogleServicesInternal",
    module_name = "GoogleServicesInternal",
    generates_header = True,
    srcs = glob([
        "Sources/**/**/*.swift",
    ]),
    copts = [
        "-warnings-as-errors",
    ],
    data = [

    ],
    deps = [
        "//submodules/GoogleUtilities:GoogleUtilities",
    ],
    visibility = [
        "//visibility:public",
    ],
)

objc_library(
    name = "GoogleServices",
    enable_modules = True,
    module_name = "GoogleServices",
    srcs = glob([
        "Sources/**/**/*.m",
        "Sources/**/**/*.mm",
        "Sources/**/**/*.h",
        "Sources/**/Sources/**/*.m",
        "Sources/**/Sources/**/*.mm",
        "Sources/**/Sources/**/*.h",
    ]),
    copts = [
        #"-warnings-as-errors",
        "-DFirebase_VERSION=10.11.0"
    ],
    deps = [
            ":GoogleServicesInternal",
            "//submodules/GoogleUtilities:GoogleUtilities",
    ],
    hdrs = glob([
        "GoogleServices-Bridging-Header.h",
        "Sources/Interop/Analytics/Public/*.h",
        "Sources/FirebaseCore/Extension/*.h",
        "Sources/FirebaseCore/Sources/Public/FirebaseCore/*.h",
        "Sources/FirebaseDynamicLink/Sources/Public/FirebaseDynamicLinks/*.h",
    ]),
    includes = [
        "Sources/Interop/Analytics/Public",
        "Sources/FirebaseCore/Extension",
        "Sources/FirebaseCore/Sources/Public/FirebaseCore",
        "Sources/FirebaseDynamicLink/Sources/Public/FirebaseDynamicLinks",
    ],
    visibility = [
        "//visibility:public",
    ],
)
