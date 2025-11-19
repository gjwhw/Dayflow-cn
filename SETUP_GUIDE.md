# Dayflow CN 仓库设置指南

## 🚀 快速设置指南

### 1. 仓库已创建 ✅
- 远程仓库：https://github.com/gjwhw/Dayflow-cn
- 当前分支：`feature/custom-build-location`
- 推送状态：进行中...

### 2. 推送完成后需要在GitHub上设置

#### A. 设置默认分支
```bash
# 推送完成后，设置主分支
git checkout -b main
git push cn-origin main

# 在GitHub上设置main为默认分支
```

#### B. 启用GitHub Pages（可选）
用于项目文档展示：
1. 进入仓库 Settings
2. 找到 Pages 部分
3. Source 选择 "Deploy from a branch"
4. Branch 选择 "main"
5. Folder 选择 "/root"
6. 点击 Save

#### C. 添加仓库描述
在GitHub仓库页面设置：
- **描述**: Dayflow 中文版 - AI工作日记录助手，完整中文化本地化
- **主题**: 推荐使用文档主题
- **标签**: ai, macos, 中文版, time-tracking, productivity

### 3. 发布版本

#### 创建GitHub Release
1. 进入仓库的 Releases 页面
2. 点击 "Create a new release"
3. **Tag**: `v1.1.21-cn`
4. **Title**: `Dayflow CN v1.1.21 - 首个中文版发布`
5. **Description**:
   ```markdown
   ## 🎉 首个中文版发布！

   ### 主要特性
   - ✅ 完整UI界面中文化
   - ✅ AI提示词中文优化
   - ✅ 中文应用识别增强
   - ✅ 本地化用户体验

   ### 安装方式
   1. 下载 `Dayflow_CN_v1.1.21.zip`
   2. 解压并拖拽到应用程序文件夹
   3. 授予屏幕录制权限
   4. 享受您的中文版时间管理助手！
   ```

### 4. 后续开发流程

#### 添加协作者
```bash
# 在GitHub仓库中添加Collaborators
# Settings -> Manage access -> Invite a collaborator
```

#### 设置分支保护规则
```bash
# 在Settings -> Branches中设置：
# 1. main分支需要PR审查
# 2. 要求状态检查通过
# 3. 禁止强制推送
```

#### 配置自动化（可选）
```yaml
# .github/workflows/build.yml
name: Build and Test
on: [push, pull_request]
jobs:
  build:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3
      - name: Build
        run: |
          xcodebuild -project Dayflow.xcodeproj -scheme Dayflow -configuration Debug build
```

### 5. 社区建设

#### Issue模板
创建 `.github/ISSUE_TEMPLATE/bug_report.md`:
```markdown
---
name: Bug报告
about: 报告一个Bug
title: '[BUG] '
labels: bug
assignees: ''
---
**描述Bug**
清晰地描述遇到的问题

**复现步骤**
1. 进入 '...'
2. 点击 '....'
3. 滚动到 '....'
4. 看到错误

**预期行为**
描述您期望发生的行为

**截图**
如果适用，添加截图来帮助解释问题

**环境信息：**
 - macOS版本: [e.g. 13.0]
 - Dayflow CN版本: [e.g. 1.1.21]
 - AI提供商: [Gemini/本地模型]
```

#### Pull Request模板
创建 `.github/pull_request_template.md`:
```markdown
## 变更描述
清晰描述您做的变更

## 变更类型
- [ ] Bug修复
- [ ] 新功能
- [ ] 文档更新
- [ ] 其他

## 测试
描述您如何测试了这些变更

## 截图（如果适用）
添加截图来展示您的变更

## 检查清单
- [ ] 我已阅读开发指南
- [ ] 代码遵循项目规范
- [ ] 我已测试我的变更
- [ ] 我已更新相关文档
```

### 6. 推广和宣传

#### README优化
```markdown
# 在README.md顶部添加徽章
![Version](https://img.shields.io/badge/version-1.1.21.cn-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![Swift](https://img.shields.io/badge/Swift-5.9-orange)
```

#### 社区分享
- 在相关中文开发者社区分享
- 在AI和Mac应用论坛介绍
- 考虑写技术博客介绍开发过程

### 7. 监控和维护

#### 设置通知
```bash
# GitHub仓库通知
# Watch -> Custom ->
# ☑️ Issues
# ☑️ Pull requests
# ☑️ Releases
```

#### 定期维护
- 每周检查新的Issues和PR
- 每月同步原版更新
- 每季度发布新版本

---

## 🎯 完成检查清单

- [ ] 代码推送完成
- [ ] GitHub仓库基本设置完成
- [ ] 创建第一个Release
- [ ] 设置Issue和PR模板
- [ ] 添加协作者（如果有）
- [ ] 分享到相关社区

完成以上设置后，您的Dayflow中文版仓库就完全准备好了！

**恭喜！您已经成功创建了Dayflow的第一个中文本地化版本！** 🎉

---
*最后更新: 2025年11月*