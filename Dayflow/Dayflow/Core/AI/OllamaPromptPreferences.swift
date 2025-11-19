import Foundation

struct OllamaPromptOverrides: Codable, Equatable {
    var summaryBlock: String?
    var titleBlock: String?

    var isEmpty: Bool {
        [summaryBlock, titleBlock].allSatisfy { value in
            let trimmed = value?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            return trimmed.isEmpty
        }
    }
}

enum OllamaPromptPreferences {
    private static let overridesKey = "ollamaPromptOverrides"
    private static let store = UserDefaults.standard

    static func load() -> OllamaPromptOverrides {
        guard let data = store.data(forKey: overridesKey) else {
            return OllamaPromptOverrides()
        }
        guard let overrides = try? JSONDecoder().decode(OllamaPromptOverrides.self, from: data) else {
            return OllamaPromptOverrides()
        }
        return overrides
    }

    static func save(_ overrides: OllamaPromptOverrides) {
        guard let data = try? JSONEncoder().encode(overrides) else { return }
        store.set(data, forKey: overridesKey)
    }

    static func reset() {
        store.removeObject(forKey: overridesKey)
    }
}

enum OllamaPromptDefaults {
    static let summaryBlock = """
          摘要指导原则：
          - 用第一人称写作但不使用"我"（像个人日记条目）
          - 最多2-3个句子
          - 包含具体细节（应用名称、搜索主题等）
          - 自然、对话式语调

          良好示例：
          "管理Mac系统偏好设置，重点关注软件更新和无障碍设置。浏览Chrome搜索iPhone无线充电信息，同时检查Twitter和Slack消息。"

          "为GitHub Actions配置自动化测试管道。快速的Slack检查中断了专注，然后回到调试部署问题。"

          "在Chrome中研究React性能优化技术，阅读关于useMemo模式的文章。在文档标签之间切换，并在Notion中记录关于组件重新渲染的笔记。"

          "更新Xcode项目依赖项并解决SwiftUI视图中的构建错误。在模拟器上测试应用，同时回复关于时间线更改的客户消息。"

          "在听Spotify播放列表的同时浏览Instagram和TikTok。在WhatsApp上回复关于周末计划的个人消息。"

          "在旅行网站上研究度假目的地并比较航班价格。在阅读旅行评论的同时检查不同城市的天气预报。"

          错误示例：
          - "用户进行了各种计算机活动"（太模糊，错误视角，永远不要说用户）
          - "我在电脑上做不同的任务"（使用了"我"，不具体）
          - "在多个应用和网站上花费时间"（通用，没有细节）
    """

    static let titleBlock = """
        标题指导原则：
        写标题就像您在给朋友发短信。保持对话式并在5-8个词内（偏向简短）。
        专注于一个突出的活动；您可以提到另一个同等重要的行动，但表达为快速的"和/当"或破折号连接（从不使用逗号列表）。
        以主动动词或应用+行动开头，最多包含一个支持细节（应用、媒介或主题）。如果您提到两个活动，要确保它们都很重要而不听起来像清单。
        描述您在应用/网站上做什么；永远不要只列出工具名称或打开的窗口。
        ⚠️ 只使用摘要中存在的细节 - 永远不要捏造上下文。

        良好示例：
        "在VS Code中调试认证流程"
        "YouTube游戏戏剧深度探索"
        "审查Figma设计"
        "部署等待期间Slack追进度"
        "为仪表板调整React hooks"

        错误示例（附解释）：

        ✗ "React编码、游戏流媒体、推文检查"
          为什么错误：列出了三种不同的活动；没有焦点或明确的要点。

        ✗ "用户参与视频通话、软件更新和浏览系统偏好设置"
          为什么错误：太长（11个词），正式的"参与"，说"用户"而不是自然的第一人称

        ✗ "浏览和浏览，回复Slack"
          为什么错误：重复的"浏览和浏览"，不清楚浏览了什么，措辞笨拙

        ✗ "（调试和编码）用户的时间跨度"
          为什么错误：奇怪的括号格式，正式的"时间跨度"，说"用户的"而不是自然语言

        ✗ "在计算机任务和应用上工作"
          为什么错误：完全通用，"在...上工作"是懒惰的，可以描述任何计算机使用
        ✗ "GitHub Desktop + 终端日志"
          为什么错误：只列出工具；不解释行动或意图
    """
}

struct OllamaPromptSections {
    let summary: String
    let title: String

    init(overrides: OllamaPromptOverrides) {
        self.summary = OllamaPromptSections.compose(defaultBlock: OllamaPromptDefaults.summaryBlock, custom: overrides.summaryBlock)
        self.title = OllamaPromptSections.compose(defaultBlock: OllamaPromptDefaults.titleBlock, custom: overrides.titleBlock)
    }

    private static func compose(defaultBlock: String, custom: String?) -> String {
        let trimmed = custom?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return trimmed.isEmpty ? defaultBlock : trimmed
    }
}
