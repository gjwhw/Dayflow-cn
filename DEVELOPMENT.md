# Dayflow 中文版开发指南

## 分支策略

### 主分支结构

```
main                    # 原版主分支（上游同步）
├── feature/*           # 功能开发分支
│   ├── custom-build-location  # 自定义构建位置（当前中文版开发分支）
│   ├── chinese-localization   # 中文化功能分支
│   └── ai-optimization        # AI优化分支
├── develop              # 开发集成分支
└── release/*           # 发布分支
    ├── v1.1.21-cn     # 中文版v1.1.21发布分支
    └── v1.2.0-cn      # 中文版v1.2.0发布分支
```

### 分支说明

#### `main`
- **用途**：跟踪原版Dayflow的最新更新
- **来源**：定期从 `https://github.com/JerryZLiu/Dayflow` 同步
- **保护**：不允许直接提交，只能通过PR合并

#### `feature/custom-build-location`
- **当前状态**：✅ 中文版主要开发分支
- **功能**：
  - 完整UI界面中文化
  - AI提示词中文优化
  - 自定义构建路径支持
  - 中文名称打包支持

#### `feature/chinese-localization`
- **状态**：规划中
- **功能**：
  - 更深度的中文化
  - 本地化AI模型集成
  - 中文应用识别优化

#### `develop`
- **用途**：开发分支集成测试
- **规则**：所有feature分支先合并到此分支进行集成测试

#### `release/*`
- **用途**：发布版本维护
- **命名**：`release/vX.Y.Z-cn`
- **特点**：只接受bug修复，不添加新功能

## 开发工作流

### 1. 功能开发流程

```bash
# 1. 从develop创建功能分支
git checkout develop
git pull origin develop
git checkout -b feature/new-feature

# 2. 开发完成后提交
git add .
git commit -m "feat: 添加新功能描述"

# 3. 推送并创建PR
git push origin feature/new-feature
# 创建PR: feature/new-feature -> develop

# 4. 代码审查通过后合并到develop
```

### 2. 中文版发布流程

```bash
# 1. 从develop创建发布分支
git checkout develop
git pull origin develop
git checkout -b release/v1.2.0-cn

# 2. 更新版本号和发布信息
# 编辑相关文件，更新版本号

# 3. 提交发布准备
git commit -m "chore: 准备v1.2.0-cn发布"

# 4. 合并到main并创建tag
git checkout main
git merge --no-ff release/v1.2.0-cn
git tag v1.2.0-cn

# 5. 推送
git push origin main
git push origin v1.2.0-cn

# 6. 合并回develop（确保后续修复）
git checkout develop
git merge --no-ff release/v1.2.0-cn
git push origin develop
```

### 3. 原版同步流程

```bash
# 1. 添加原版上游仓库
git remote add upstream https://github.com/JerryZLiu/Dayflow.git

# 2. 拉取原版更新
git fetch upstream
git checkout main
git merge upstream/main

# 3. 解决冲突（如果有）
# 手动解决冲突并提交

# 4. 推送更新
git push origin main

# 5. 将更新合并到开发分支
git checkout develop
git merge main
git push origin develop
```

## 代码规范

### 提交信息规范

使用 [Conventional Commits](https://conventionalcommits.org/) 规范：

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

#### 类型说明
- `feat`: 新功能
- `fix`: Bug修复
- `docs`: 文档更新
- `style`: 代码格式化（不影响功能）
- `refactor`: 代码重构
- `test`: 测试相关
- `chore`: 构建工具或辅助工具的变动

#### 示例
```bash
feat(ui): 添加中文设置页面
fix(ai): 修复Gemini API调用错误
docs(readme): 更新安装说明
refactor(core): 重构录制模块架构
```

### 代码审查要求

#### 所有PR必须：
1. **通过所有测试**
2. **代码格式一致**
3. **包含必要的文档**
4. **通过安全检查**

#### 审查重点
- 🔒 **数据安全**：确保不泄露用户隐私
- 🌏 **中文化质量**：确保中文翻译准确
- 🚀 **性能影响**：确保不影响应用性能
- 🧪 **测试覆盖**：新功能必须有测试

## 构建和发布

### 开发环境构建

```bash
# 1. 克隆项目
git clone https://github.com/your-username/dayflow-cn.git
cd dayflow-cn

# 2. 安装依赖（如果需要）
# 使用Swift Package Manager，Xcode会自动处理

# 3. 打开Xcode
open Dayflow.xcodeproj

# 4. 配置运行环境
# 在scheme中添加环境变量：
# - GEMINI_API_KEY (如果使用Gemini)
# - DEVELOPMENT_MODE = true
```

### 生产构建

```bash
# 1. 使用构建脚本
./scripts/build-release.sh

# 2. 或使用Xcode Archive
# Product -> Archive
# 选择 "Distribute App"
```

### 版本打包

当前使用自定义构建脚本 `build-dev-final.sh`：

```bash
# 支持中文版打包
./build-dev-final.sh

# 输出：
# - build-dev/Dayflow CN.app
# - build-dev/Dayflow_CN_v1.1.21.zip
```

## 质量保证

### 自动化检查

- ✅ **SwiftLint**: 代码风格检查
- ✅ **单元测试**: 核心功能测试
- ✅ **集成测试**: 端到端测试
- ✅ **安全扫描**: 依赖安全检查

### 发布检查清单

#### 功能测试
- [ ] 所有核心功能正常
- [ ] AI分析准确无误
- [ ] 中文本地化完整
- [ ] 设置页面功能正常
- [ ] 时间线展示正确

#### 性能测试
- [ ] 内存使用 < 150MB
- [ ] CPU使用 < 2% (空闲时)
- [ ] 录制性能正常
- [ ] AI分析速度可接受

#### 安全检查
- [ ] API密钥安全存储
- [ ] 数据本地加密
- [ ] 网络请求验证
- [ ] 权限使用最小化

## 发布计划

### v1.1.21 (当前版本)
- ✅ 完整UI中文化
- ✅ AI提示词中文优化
- ✅ 自定义构建支持
- ✅ 版本打包自动化

### v1.2.0 (计划中)
- 🔄 更多中文AI模型支持
- 🔄 本地化数据报告
- 🔄 智能中文应用识别
- 🔄 性能优化

### v1.3.0 (规划中)
- 📋 中文语音识别
- 📋 智能分类建议
- 📋 团队协作功能
- 📋 数据导入导出

## 社区参与

### 贡献方式

1. **报告问题**: 使用GitHub Issues
2. **功能建议**: 在Issues中讨论
3. **代码贡献**: 提交Pull Request
4. **文档改进**: 完善中文化文档

### 沟通渠道

- 📦 **GitHub Issues**: [提交问题](https://github.com/gjwhw/Dayflow-cn/issues)
- 💬 **GitHub Discussions**: [功能讨论](https://github.com/gjwhw/Dayflow-cn/discussions)
- 📧 **邮件联系**: 通过项目维护者联系

### 贡献者名单

感谢所有为Dayflow中文版做出贡献的开发者！

## 许可证

本项目遵循 MIT 许可证。详见 [LICENSE](LICENSE) 和 [LICENSE_CN.md](LICENSE_CN.md)。

---

**让AI更好地服务中文用户，打造最优秀的时间管理工具！** 🇨🇳