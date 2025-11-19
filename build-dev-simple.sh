#!/bin/bash

# Dayflow 开发版本构建脚本 (简化版)
# 创建一个与正式版本区分的开发版本

set -e

echo "🚀 开始构建 Dayflow 开发版本..."

# 设置变量
PROJECT_DIR="./Dayflow"
PROJECT_NAME="Dayflow"
SCHEME_NAME="Dayflow"
CONFIGURATION="Debug"
OUTPUT_DIR="./build-dev"
DEV_APP_NAME="Dayflow Dev"

# 创建输出目录
mkdir -p "$OUTPUT_DIR"

echo "🔨 构建开发版本..."

# 使用自定义参数构建
/Applications/Xcode.app/Contents/Developer/usr/bin/xcodebuild \
    -project "$PROJECT_DIR/Dayflow.xcodeproj" \
    -scheme "$SCHEME_NAME" \
    -configuration "$CONFIGURATION" \
    -derivedDataPath "$OUTPUT_DIR/DerivedData" \
    INFOPLIST_FILE="$PROJECT_DIR/Info-Dev.plist" \
    PRODUCT_NAME="$DEV_APP_NAME" \
    CODE_SIGN_IDENTITY="" \
    CODE_SIGNING_REQUIRED=NO \
    clean build

echo "📦 复制应用到输出目录..."
cp -R "$OUTPUT_DIR/DerivedData/Build/Products/Debug/Dayflow.app" "$OUTPUT_DIR/${DEV_APP_NAME}.app"

echo "🏷️ 修改应用包信息..."
# 修改应用包内的 Info.plist
/usr/libexec/PlistBuddy -c "Set :CFBundleDisplayName '$DEV_APP_NAME'" "$OUTPUT_DIR/${DEV_APP_NAME}.app/Contents/Info.plist" 2>/dev/null || echo "DisplayName already set"
/usr/libexec/PlistBuddy -c "Set :CFBundleName '$DEV_APP_NAME'" "$OUTPUT_DIR/${DEV_APP_NAME}.app/Contents/Info.plist" 2>/dev/null || echo "BundleName already set"

echo "✅ 构建完成！"
echo "📍 开发版本位置: $OUTPUT_DIR/${DEV_APP_NAME}.app"
echo "🎯 应用名称: $DEV_APP_NAME"
echo ""
echo "🚀 运行开发版本: open \"$OUTPUT_DIR/${DEV_APP_NAME}.app\""