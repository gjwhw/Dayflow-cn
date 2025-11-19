#!/bin/bash

# Dayflow 开发版本构建脚本
# 创建一个名为 "Dayflow Dev" 的开发版本，与正式版本区分

set -e

echo "🚀 开始构建 Dayflow 开发版本..."

# 设置变量
PROJECT_NAME="Dayflow"
SCHEME_NAME="Dayflow"
CONFIGURATION="Debug"
OUTPUT_DIR="./build-dev"
DEV_BUNDLE_ID="teleportlabs.com.Dayflow.dev"
DEV_APP_NAME="Dayflow Dev"

# 创建输出目录
mkdir -p "$OUTPUT_DIR"

echo "📝 设置开发版本配置..."

# 复制项目文件以创建开发版本配置
cp "./Dayflow/Dayflow.xcodeproj/project.pbxproj" "./Dayflow/Dayflow.xcodeproj/project.pbxproj.backup"

# 构建应用，使用自定义 Info.plist
echo "🔨 构建开发版本..."
/Applications/Xcode.app/Contents/Developer/usr/bin/xcodebuild \
    -project "./Dayflow/Dayflow.xcodeproj" \
    -scheme "$SCHEME_NAME" \
    -configuration "$CONFIGURATION" \
    -derivedDataPath "$OUTPUT_DIR/DerivedData" \
    INFOPLIST_FILE="Dayflow/Dayflow/Info-Dev.plist" \
    PRODUCT_BUNDLE_IDENTIFIER="$DEV_BUNDLE_ID" \
    PRODUCT_NAME="$DEV_APP_NAME" \
    CODE_SIGN_IDENTITY="" \
    CODE_SIGNING_REQUIRED=NO \
    clean build

echo "📦 复制应用到输出目录..."
cp -R "$OUTPUT_DIR/DerivedData/Build/Products/Debug/Dayflow.app" "$OUTPUT_DIR/${DEV_APP_NAME}.app"

echo "🏗️ 更新应用包信息..."
# 修改应用包内的 Info.plist
/usr/libexec/PlistBuddy -c "Set :CFBundleDisplayName '$DEV_APP_NAME'" "$OUTPUT_DIR/${DEV_APP_NAME}.app/Contents/Info.plist"
/usr/libexec/PlistBuddy -c "Set :CFBundleName '$DEV_APP_NAME'" "$OUTPUT_DIR/${DEV_APP_NAME}.app/Contents/Info.plist"
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString '1.1.21-dev'" "$OUTPUT_DIR/${DEV_APP_NAME}.app/Contents/Info.plist"
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion '61-dev'" "$OUTPUT_DIR/${DEV_APP_NAME}.app/Contents/Info.plist"

# 修改 Bundle ID
/usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier '$DEV_BUNDLE_ID'" "$OUTPUT_DIR/${DEV_APP_NAME}.app/Contents/Info.plist"

echo "✅ 构建完成！"
echo "📍 开发版本位置: $OUTPUT_DIR/${DEV_APP_NAME}.app"
echo "🎯 应用名称: $DEV_APP_NAME"
echo "🏷️ Bundle ID: $DEV_BUNDLE_ID"
echo ""
echo "🚀 运行开发版本: open \"$OUTPUT_DIR/${DEV_APP_NAME}.app\""