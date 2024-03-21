load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")
load(
    "@build_bazel_rules_apple//apple:resources.bzl",
    "apple_resource_bundle",
    "apple_resource_group",
)
load("//build-system/bazel-utils:plist_fragment.bzl",
    "plist_fragment",
)

load(
    "@build_configuration//:variables.bzl",
    "telegram_bundle_id",
)

internal_bundle_ids = [
    "com.swordpay.me",
]

swift_library(
    name = "SwordAppArch",
    module_name = "SwordAppArch",
    srcs = glob([
        "Sources/**/*.swift",
        "Sources/**/**/*.swift",
    ]),
    copts = [
        "-warnings-as-errors",
    ],
    data = [
        ":SwordAppArchBundle",
    ],
    deps = [
        "//submodules/Swinject:Swinject",
        "//submodules/GoogleServices:GoogleServices",
        "//submodules/SocketIO:SocketIO",
        "//submodules/lottie-ios:Lottie",
        "//submodules/Components/LottieAnimationComponent:LottieAnimationComponent",
        "//submodules/Kingfisher:Kingfisher",
        "//submodules/Reachability:Reachability",
        "//submodules/Display:Display",
        "//submodules/AccountContext:AccountContext",
        "//submodules/TelegramPresentationData:TelegramPresentationData",
        "//submodules/TelegramCore:TelegramCore",
        "//submodules/TelegramApi:TelegramApi",
        "//submodules/Postbox:Postbox",
        "//submodules/AvatarNode:AvatarNode",
        "//submodules/TabBarUI:TabBarUI",
        "//submodules/PhoneNumberFormat:PhoneNumberFormat",
        "//submodules/LegacyComponents:LegacyComponents",
        "//submodules/SwordCharts:SwordCharts",
        "//submodules/PresentationDataUtils:PresentationDataUtils",
        "//submodules/QrCode:QrCode",
        "//submodules/ContactListUI:ContactListUI",
        "//submodules/PhotoResources:PhotoResources",
        "//submodules/TinyThumbnail:TinyThumbnail",
        "//submodules/MozjpegBinding:MozjpegBinding",
        "//submodules/FastBlur:FastBlur",
        "//submodules/RadialStatusNode:RadialStatusNode",
        "//submodules/Svg:Svg"
    ],
    visibility = [
        "//visibility:public",
    ],
)

filegroup(
    name = "SwordUIComponents",
    srcs = glob([
        "Sources/MockJsons/*.json",
        "Sources/**/**/SwordLocalizable.strings",
        "Sources/**/**/*.xcassets/**",
        "Sources/**/**/*.xib",
        "Sources/**/**/**/*.xib",
        "Sources/**/**/**/**/*.xib",
        "Sources/**/**/**/**/**/*.xib",
        "Sources/**/**/**/**/**/*.xib",
        "Sources/**/**/**/**/**/*.xib",
        "Sources/**/**/**/*.json",
    ]),
    visibility = ["//visibility:public"],
)

plist_fragment(
    name = "SwordAppArchBundleInfoPlist",
    extension = "plist",
    template =
    """
    <key>CFBundleIdentifier</key>
    <string>com.swordpay.app</string>
    <key>CFBundleDevelopmentRegion</key>
    <string>en</string>
    <key>CFBundleName</key>
    <string>SwordAppArch</string>
    """
)

apple_resource_bundle(
    name = "SwordAppArchBundle",
    infoplists = [
        ":SwordAppArchBundleInfoPlist"
    ],
    resources = [
        ":SwordUIComponents",
    ],
)
