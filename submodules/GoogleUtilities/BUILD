load(
    "@build_bazel_rules_apple//apple:resources.bzl",
    "apple_resource_bundle",
    "apple_resource_group",
)
load("//build-system/bazel-utils:plist_fragment.bzl",
    "plist_fragment",
)

objc_library(
    name = "GoogleUtilities",
    module_name = "GoogleUtilities",
    srcs = glob([
        "Sources/**/**/*.m",
        "Sources/**/**/*.mm",
        "Sources/**/Sources/**/*.m",
        "Sources/**/Sources/**/*.mm",
    ]),
    copts = [
        #"-warnings-as-errors",
    ],
    deps = [
    ],
    data = [
        ":GoogleUtilitiesBundle",
    ],
    hdrs = glob([
        "Sources/Logger/Public/GoogleUtilities/*.h",
        "Sources/Environment/Public/GoogleUtilities/*.h",
        "Sources/Promises/FBLPromises/include/*.h",
    ]),
    includes = [
        "Sources/Logger/Public/GoogleUtilities",
        "Sources/Environment/Public/GoogleUtilities",
        "Sources/Promises/FBLPromises/include",
    ],
    visibility = [
        "//visibility:public",
    ],
)

filegroup(
    name = "GoogleUtilitiesPromisesModules",
    srcs = glob([
        "Sources/**/**/module.modulemap",
        "Sources/**/**/framework.modulemap",
    ]),
    visibility = ["//visibility:public"],
)

plist_fragment(
    name = "GoogleUtilitiesBundleInfoPlist",
    extension = "plist",
    template =
    """
    <key>CFBundleIdentifier</key>
    <string>com.swordpay.googleUtilities</string>
    <key>CFBundleDevelopmentRegion</key>
    <string>en</string>
    <key>CFBundleName</key>
    <string>GoogleUtilities</string>
    """
)

apple_resource_bundle(
    name = "GoogleUtilitiesBundle",
    infoplists = [
        ":GoogleUtilitiesBundleInfoPlist"
    ],
    resources = [
        ":GoogleUtilitiesPromisesModules",
    ],
)
