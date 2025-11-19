# Dayflow 构建指南

## 可用的构建选项

### 1. 覆盖构建（默认）- `build-dev-final.sh`
```bash
./build-dev-final.sh
```
- ✅ **行为**: 每次完全覆盖之前的开发版本
- ✅ **用途**: 日常开发，不需要旧版本时使用
- ⚠️ **注意**: 会删除之前的开发版本应用，但用户数据保留在 `~/Library/Application Support/Dayflow Dev`

### 2. 增量构建 - `build-dev-incremental.sh`
```bash
./build-dev-incremental.sh
```
- ✅ **行为**: 保留现有数据，只更新应用二进制文件
- ✅ **用途**: 修复bug或小改动时使用，保持连续性
- 🔄 **备份**: 自动备份旧版本到 `build-dev-backup-{timestamp}`

### 3. 版本化构建 - `build-dev-versioned.sh`
```bash
./build-dev-versioned.sh              # 自动生成版本名
./build-dev-versioned.sh feature-xyz  # 使用自定义版本名
```
- ✅ **行为**: 创建完全独立的版本，不会覆盖任何现有版本
- ✅ **用途**:
  - 测试不同功能分支
  - 保存重要版本用于对比
  - 多人协作时各自测试
- 📁 **输出**: `./build-dev-{version-name}/`

## 数据存储位置

### 正式版本
- 应用数据: `~/Library/Application Support/Dayflow/`
- 录制文件: `~/Library/Application Support/Dayflow/recordings/`

### 开发版本
- 应用数据: `~/Library/Application Support/Dayflow Dev/`
- 录制文件: `~/Library/Application Support/Dayflow Dev/recordings/`

### 版本化构建
- 应用数据: `~/Library/Application Support/Dayflow Dev ({version-name})/`
- 录制文件: `~/Library/Application Support/Dayflow Dev ({version-name})/recordings/`

## 推荐工作流程

### 日常开发
```bash
# 使用增量构建，保持数据连续性
./build-dev-incremental.sh
```

### 功能分支测试
```bash
# 创建独立版本测试
./build-dev-versioned.sh feature-new-ui
```

### 重要里程碑
```bash
# 保存当前版本用于对比
./build-dev-versioned.sh milestone-v1.2
```

### 清理和重建
```bash
# 完全重新构建
./build-dev-final.sh
```

## 版本识别

不同构建方式的应用在系统中显示为：

| 构建类型 | 应用名称 | Bundle ID |
|---------|----------|-----------|
| 覆盖构建 | Dayflow Dev | teleportlabs.com.Dayflow.dev |
| 增量构建 | Dayflow Dev | teleportlabs.com.Dayflow.dev |
| 版本化构建 | Dayflow Dev (feature-xyz) | teleportlabs.com.Dayflow.dev.feature-xyz |

## 快速对比不同版本

```bash
# 查看所有构建版本
ls -la build-dev*

# 同时运行多个版本对比
open "./build-dev/Dayflow Dev.app"
open "./build-dev-feature-new-ui/Dayflow Dev (feature-new-ui).app"
```

## 清理旧版本

```bash
# 清理所有开发版本
rm -rf build-dev-*

# 清理特定版本
rm -rf build-dev-feature-xyz
```