#!/bin/bash

# Dayflow 开发版本增量构建脚本
# 保留现有数据，只更新应用二进制文件

set -e

echo "🔄 增量构建Dayflow开发版本..."

# 设置变量
OUTPUT_DIR="./build-dev"
DEV_APP_NAME="Dayflow Dev"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR="./build-dev-backup-${TIMESTAMP}"

# 如果存在旧版本，先备份数据
if [ -d "$OUTPUT_DIR" ]; then
    echo "📦 备份现有开发版本数据..."
    mkdir -p "$BACKUP_DIR"

    # 备份应用数据目录（如果存在）
    if [ -d "$OUTPUT_DIR/${DEV_APP_NAME}.app" ]; then
        # 备份整个应用包
        cp -R "$OUTPUT_DIR/${DEV_APP_NAME}.app" "$BACKUP_DIR/"
    fi

    echo "💾 备份完成: $BACKUP_DIR"
fi

# 创建输出目录
mkdir -p "$OUTPUT_DIR"

echo "🔨 构建应用..."
# 只构建，不清理（增量构建）
/Applications/Xcode.app/Contents/Developer/usr/bin/xcodebuild \
    -project "./Dayflow/Dayflow.xcodeproj" \
    -scheme Dayflow \
    -configuration Debug \
    CODE_SIGN_IDENTITY="" \
    CODE_SIGNING_REQUIRED=NO \
    build

echo "📦 更新开发版本..."
# 保存数据目录（如果存在）
DATA_DIR="$HOME/Library/Application Support/Dayflow Dev"
if [ -d "$DATA_DIR" ]; then
    echo "📋 保留应用数据目录..."
    # 数据目录会自动保留，因为Bundle ID不变
fi

# 复制新的应用二进制文件
rm -rf "$OUTPUT_DIR/${DEV_APP_NAME}.app"
cp -R "/Users/h3glove/Library/Developer/Xcode/DerivedData/Dayflow-essstssbtaiddhepsndbybqwlqjt/Build/Products/Debug/Dayflow.app" "$OUTPUT_DIR/${DEV_APP_NAME}.app"

# 确保应用信息正确
/usr/libexec/PlistBuddy -c "Add :CFBundleDisplayName string '$DEV_APP_NAME'" "$OUTPUT_DIR/${DEV_APP_NAME}.app/Contents/Info.plist" 2>/dev/null || true
/usr/libexec/PlistBuddy -c "Add :CFBundleName string '$DEV_APP_NAME'" "$OUTPUT_DIR/${DEV_APP_NAME}.app/Contents/Info.plist" 2>/dev/null || true
/usr/libexec/PlistBuddy -c "Set :CFBundleDisplayName '$DEV_APP_NAME'" "$OUTPUT_DIR/${DEV_APP_NAME}.app/Contents/Info.plist"
/usr/libexec/PlistBuddy -c "Set :CFBundleName '$DEV_APP_NAME'" "$OUTPUT_DIR/${DEV_APP_NAME}.app/Contents/Info.plist"
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString '1.1.21-dev'" "$OUTPUT_DIR/${DEV_APP_NAME}.app/Contents/Info.plist"
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion '61-dev'" "$OUTPUT_DIR/${DEV_APP_NAME}.app/Contents/Info.plist"
/usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier 'teleportlabs.com.Dayflow.dev'" "$OUTPUT_DIR/${DEV_APP_NAME}.app/Contents/Info.plist"

echo "✅ 增量构建完成！"
echo ""
echo "📱 应用信息:"
echo "   名称: $DEV_APP_NAME"
echo "   位置: $OUTPUT_DIR/${DEV_APP_NAME}.app"
echo "   数据目录: $DATA_DIR (已保留)"
echo ""
if [ -d "$BACKUP_DIR" ]; then
    echo "💾 备份位置: $BACKUP_DIR"
    echo ""
fi
echo "🚀 运行开发版本: open \"$OUTPUT_DIR/${DEV_APP_NAME}.app\""