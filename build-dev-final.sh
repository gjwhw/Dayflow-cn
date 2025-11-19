#!/bin/bash

# Dayflow 开发版本构建脚本
# 用于创建与正式版本区分的开发版本

set -e

echo "🚀 构建Dayflow开发版本..."

# 设置变量
OUTPUT_DIR="./build-dev"
DEV_APP_NAME="Dayflow CN"

# 清理旧的构建目录
if [ -d "$OUTPUT_DIR" ]; then
    echo "🧹 清理旧的构建文件..."
    rm -rf "$OUTPUT_DIR"
fi

# 创建输出目录
mkdir -p "$OUTPUT_DIR"

echo "🔨 构建应用..."
# 构建应用（使用缓存，不需要每次重新下载依赖）
/Applications/Xcode.app/Contents/Developer/usr/bin/xcodebuild \
    -project "./Dayflow/Dayflow.xcodeproj" \
    -scheme Dayflow \
    -configuration Debug \
    CODE_SIGN_IDENTITY="" \
    CODE_SIGNING_REQUIRED=NO \
    build

echo "📦 复制并修改开发版本..."
# 复制到开发版本目录
cp -R "/Users/h3glove/Library/Developer/Xcode/DerivedData/Dayflow-essstssbtaiddhepsndbybqwlqjt/Build/Products/Debug/Dayflow.app" "$OUTPUT_DIR/${DEV_APP_NAME}.app"

# 修改应用信息 - 关键：修改Bundle ID和可执行文件名
/usr/libexec/PlistBuddy -c "Add :CFBundleDisplayName string '$DEV_APP_NAME'" "$OUTPUT_DIR/${DEV_APP_NAME}.app/Contents/Info.plist" 2>/dev/null || true
/usr/libexec/PlistBuddy -c "Add :CFBundleName string '$DEV_APP_NAME'" "$OUTPUT_DIR/${DEV_APP_NAME}.app/Contents/Info.plist" 2>/dev/null || true
/usr/libexec/PlistBuddy -c "Set :CFBundleDisplayName '$DEV_APP_NAME'" "$OUTPUT_DIR/${DEV_APP_NAME}.app/Contents/Info.plist"
/usr/libexec/PlistBuddy -c "Set :CFBundleName '$DEV_APP_NAME'" "$OUTPUT_DIR/${DEV_APP_NAME}.app/Contents/Info.plist"
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString '1.1.21-cn'" "$OUTPUT_DIR/${DEV_APP_NAME}.app/Contents/Info.plist"
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion '61-cn'" "$OUTPUT_DIR/${DEV_APP_NAME}.app/Contents/Info.plist"
/usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier 'teleportlabs.com.Dayflow.cn'" "$OUTPUT_DIR/${DEV_APP_NAME}.app/Contents/Info.plist"
/usr/libexec/PlistBuddy -c "Set :CFBundleExecutable '$DEV_APP_NAME'" "$OUTPUT_DIR/${DEV_APP_NAME}.app/Contents/Info.plist"

# 重命名可执行文件
mv "$OUTPUT_DIR/${DEV_APP_NAME}.app/Contents/MacOS/Dayflow" "$OUTPUT_DIR/${DEV_APP_NAME}.app/Contents/MacOS/$DEV_APP_NAME"

echo "✅ 构建完成！"
echo ""
echo "📱 应用信息:"
echo "   名称: $DEV_APP_NAME"
echo "   版本: 1.1.21-cn"
echo "   Bundle ID: teleportlabs.com.Dayflow.cn"
echo "   位置: $OUTPUT_DIR/${DEV_APP_NAME}.app"
echo ""
echo "🚀 运行中文版本: open \"$OUTPUT_DIR/${DEV_APP_NAME}.app\""
echo ""
echo "💡 提示:"
echo "   - 中文版本与正式版本完全独立，数据不共享"
echo "   - 两个版本可以同时运行"
echo "   - 中文版本显示为 '$DEV_APP_NAME'"