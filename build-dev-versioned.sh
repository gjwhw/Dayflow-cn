#!/bin/bash

# Dayflow 开发版本化构建脚本
# 为每次构建创建带时间戳的版本，避免覆盖

set -e

# 设置变量
VERSION_NAME=${1:-"dev-$(date +"%Y%m%d_%H%M%S")"}
OUTPUT_DIR="./build-dev-${VERSION_NAME}"
DEV_APP_NAME="Dayflow Dev ($VERSION_NAME)"

echo "🚀 构建版本化Dayflow开发版本: $VERSION_NAME"

# 创建带版本号的输出目录
mkdir -p "$OUTPUT_DIR"

echo "🔨 构建应用..."
# 构建应用
/Applications/Xcode.app/Contents/Developer/usr/bin/xcodebuild \
    -project "./Dayflow/Dayflow.xcodeproj" \
    -scheme Dayflow \
    -configuration Debug \
    CODE_SIGN_IDENTITY="" \
    CODE_SIGNING_REQUIRED=NO \
    build

echo "📦 创建版本化开发版本..."
# 复制到版本化目录
cp -R "/Users/h3glove/Library/Developer/Xcode/DerivedData/Dayflow-essstssbtaiddhepsndbybqwlqjt/Build/Products/Debug/Dayflow.app" "$OUTPUT_DIR/${DEV_APP_NAME}.app"

# 修改应用信息，包含版本标识
/usr/libexec/PlistBuddy -c "Add :CFBundleDisplayName string '$DEV_APP_NAME'" "$OUTPUT_DIR/${DEV_APP_NAME}.app/Contents/Info.plist" 2>/dev/null || true
/usr/libexec/PlistBuddy -c "Add :CFBundleName string '$DEV_APP_NAME'" "$OUTPUT_DIR/${DEV_APP_NAME}.app/Contents/Info.plist" 2>/dev/null || true
/usr/libexec/PlistBuddy -c "Set :CFBundleDisplayName '$DEV_APP_NAME'" "$OUTPUT_DIR/${DEV_APP_NAME}.app/Contents/Info.plist"
/usr/libexec/PlistBuddy -c "Set :CFBundleName '$DEV_APP_NAME'" "$OUTPUT_DIR/${DEV_APP_NAME}.app/Contents/Info.plist"
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString '1.1.21-dev-$VERSION_NAME'" "$OUTPUT_DIR/${DEV_APP_NAME}.app/Contents/Info.plist"
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion '61-dev-$VERSION_NAME'" "$OUTPUT_DIR/${DEV_APP_NAME}.app/Contents/Info.plist"
/usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier 'teleportlabs.com.Dayflow.dev.$VERSION_NAME'" "$OUTPUT_DIR/${DEV_APP_NAME}.app/Contents/Info.plist"

echo "✅ 版本化构建完成！"
echo ""
echo "📱 应用信息:"
echo "   名称: $DEV_APP_NAME"
echo "   版本: 1.1.21-dev-$VERSION_NAME"
echo "   Bundle ID: teleportlabs.com.Dayflow.dev.$VERSION_NAME"
echo "   位置: $OUTPUT_DIR/${DEV_APP_NAME}.app"
echo ""
echo "🚀 运行此版本: open \"$OUTPUT_DIR/${DEV_APP_NAME}.app\""
echo ""
echo "💡 使用方法:"
echo "   ./build-dev-versioned.sh                 # 自动生成版本名"
echo "   ./build-dev-versioned.sh feature-xyz     # 使用自定义版本名"