import Foundation

struct GeminiPromptOverrides: Codable, Equatable {
    var titleBlock: String?
    var summaryBlock: String?
    var detailedBlock: String?

    var isEmpty: Bool {
        let values = [titleBlock, summaryBlock, detailedBlock]
        return values.allSatisfy { value in
            let trimmed = value?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            return trimmed.isEmpty
        }
    }
}

enum GeminiPromptPreferences {
    private static let overridesKey = "geminiPromptOverrides"
    private static let store = UserDefaults.standard

    static func load() -> GeminiPromptOverrides {
        guard let data = store.data(forKey: overridesKey) else {
            return GeminiPromptOverrides()
        }
        guard let overrides = try? JSONDecoder().decode(GeminiPromptOverrides.self, from: data) else {
            return GeminiPromptOverrides()
        }
        return overrides
    }

    static func save(_ overrides: GeminiPromptOverrides) {
        guard let data = try? JSONEncoder().encode(overrides) else { return }
        store.set(data, forKey: overridesKey)
    }

    static func reset() {
        store.removeObject(forKey: overridesKey)
    }
}

enum GeminiPromptDefaults {
    static let titleBlock = """
标题指导原则：
写标题就像您在给朋友发短信说明您做了什么。自然、对话式、直接、具体。

## 重要输出要求：
**请使用中文（简体中文）输出所有标题内容，不要使用英文。**

规则：
- 具体清晰（不创意或模糊）
- 简短 - 目标5-10个词
- 不要引用其他卡片或假设上下文
- 包含主要活动 + 如果相关的话还有分心
- 包含特定的应用/工具名称，而不是通用活动
- 使用特定动词："调试Python"而不是"在项目上工作"

良好示例：
- "在React中调试认证流程"
- "Excel预算分析第四季度报告"
- "与设计团队进行Zoom通话"
- "在Expedia为丹佛旅行预订航班"
- "在HBO观看《继承之战》大结局"
- "购物清单和备餐研究"
- "关于阴谋论的Reddit深度探索"
- "30分钟随机YouTube短视频"
- "Instagram视频和Twitter浏览"

错误示例：
- "早晨的数字漂流"（太模糊/诗意）
- "午饭后深度探索"（太长，假设上下文）
- "扩展浏览会话"（太正式）
- "随机浏览和活动"（不具体）
- "从之前继续"（引用其他卡片）
- "在DayFlow项目上工作"（太通用 - 具体是什么？）
- "浏览社交媒体和购物"（哪些平台？为了什么？）
- "优化UI和提示词"（哪些工具？什么UI？）
"""

    static let summaryBlock = """
摘要指导原则：
写简要的事实摘要，优化快速扫描。第一人称视角但不使用"我"。

## 重要输出要求：
**请使用中文（简体中文）输出所有摘要内容，不要使用英文。**

关键规则 - 绝不：
- 使用第三人称（"这个会话"，"这项工作"）
- 假设未来的行动、心理状态或无法验证的细节
- 添加填充短语如"开始"，"深入"，"以...开始"，"首先"
- 写超过2-3个短句
- 在不同摘要中重复相同的短语

风格指导原则：
- 直接说明发生了什么 - 不加开场白
- 简明列出活动和工具
- 简要提及主要中断或上下文切换
- 保持技术术语简单

内容规则：
- 最多2-3个句子
- 只说事实：您做了什么，使用了哪些工具/项目，主要障碍
- 包含特定名称（应用、工具、网站）而不是通用术语
- 简要记录模式中断而不详细说明

良好示例：
"重构了React中的用户认证模块，添加了OAuth支持。调试后端API的CORS问题一小时。当修复无效时在Stack Overflow上发布问题。"

"在Figma中设计新着陆页面模型。导出资产并开始在Next.js中实现，然后被拉入一个长时间运行的客户会议。"

"研究了跨SaaS平台的竞争对手定价模型。建立比较电子表格并编写建议。被分心阅读一篇关于定价心理学的文章。"

"在GitHub Actions中配置CI/CD管道。测试在构建步骤上不断失败，结果是Node版本不匹配。修复并部署到测试环境。"

错误示例：
"早晨通过深入一些设计工作来启动，然后过渡到开发任务。这个会话总体上相当高效。"
（太模糊，不必要的转换，没有具体说明）

"从重构认证系统开始，然后转调试出现的问题。最终花时间在线上研究解决方案。"
（冗长，缺乏具体内容，可以减少一半长度）

"通过审查代码库开始，然后深入实现新功能。工作涉及应用程序不同部分之间的多个上下文切换。"
（全是填充内容，没有实际信息）
"""

    static let detailedSummaryBlock = """
详细摘要指导原则：
detailedSummary字段必须提供卡片持续时间内的分钟级时间线。这是一个显示每个上下文切换和所花费时间的细粒度活动日志。

## 重要输出要求：
**请使用中文（简体中文）输出所有详细摘要内容，不要使用英文。**

格式规则：
- 使用精确时间范围，格式为"H:MM AM/PM - H:MM AM/PM"
- 每行一个活动
- 保持描述简短和具体（通常2-5个词）
- 包含应用/工具名称
- 显示所有上下文切换，即使是简短的
- 按时间顺序
- 无叙述文本，仅时间线

结构：
"[开始时间] - [结束时间] [在工具/应用中的具体活动]"

良好详细摘要格式的示例：
"7:00 AM - 7:30 AM 编写Notion文档
7:30 AM - 7:35 AM 回复Slack私信
7:35 AM - 7:38 AM 浏览X.com
7:38 AM - 7:45 AM 编写Notion文档
7:45 AM - 8:05 AM 在Cursor和iTerm中编码
8:05 AM - 8:08 AM 检查Gmail
8:08 AM - 8:25 AM 在VS Code中调试
8:25 AM - 8:30 AM Stack Overflow研究"

"2:15 PM - 2:18 PM 打开Figma
2:18 PM - 2:45 PM 设计着陆页面模型
2:45 PM - 2:47 PM 快速Twitter检查
2:47 PM - 3:10 PM 继续Figma设计
3:10 PM - 3:15 PM 导出资产
3:15 PM - 3:30 PM 在Next.js中实现"

错误示例（请勿执行）：
- "在整个会话中处理各种任务"（不够细化）
- "从邮件开始，然后转到编码"（叙述性，不是时间线）
- "邮件15分钟，编码30分钟"（基于持续时间，不是基于时间）
- 缺少具体时间或工具
"""
}

struct GeminiPromptSections {
    let title: String
    let summary: String
    let detailedSummary: String

    init(overrides: GeminiPromptOverrides) {
        self.title = GeminiPromptSections.compose(defaultBlock: GeminiPromptDefaults.titleBlock, custom: overrides.titleBlock)
        self.summary = GeminiPromptSections.compose(defaultBlock: GeminiPromptDefaults.summaryBlock, custom: overrides.summaryBlock)
        self.detailedSummary = GeminiPromptSections.compose(defaultBlock: GeminiPromptDefaults.detailedSummaryBlock, custom: overrides.detailedBlock)
    }

    private static func compose(defaultBlock: String, custom: String?) -> String {
        let trimmed = custom?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return trimmed.isEmpty ? defaultBlock : trimmed
    }
}
