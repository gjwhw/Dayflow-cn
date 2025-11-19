import Foundation

struct LocalModelInstructionSet {
    let title: String
    let subtitle: String
    let bullets: [String]
    let commandTitle: String?
    let commandSubtitle: String?
    let command: String?
    let buttonTitle: String?
    let buttonURL: URL?
    let note: String?
}

enum LocalModelPreset: String, CaseIterable, Codable {
    case qwen3VL4B = "qwen3_vl_4b"
    case qwen25VL3B = "qwen25_vl_3b"

    static let recommended: LocalModelPreset = .qwen3VL4B

    var displayName: String {
        switch self {
        case .qwen3VL4B: return "Qwen3-VL 4B"
        case .qwen25VL3B: return "Qwen2.5-VL 3B"
        }
    }

    var highlightBullets: [String] {
        switch self {
        case .qwen3VL4B:
            return [
                "New, most powerful local VLM",
                "Longer reasoning chains for complex sessions",
                "Fits on most Apple Silicon machines (≈5GB VRAM)"
            ]
        case .qwen25VL3B:
            return [
                "Legacy default for Dayflow local mode",
                "Lower VRAM footprint but weaker perception"
            ]
        }
    }

    func modelId(for engine: LocalEngine) -> String {
        switch (self, engine) {
        case (.qwen3VL4B, .lmstudio):
            return "Qwen3-VL-4B-Instruct"
        case (.qwen25VL3B, .lmstudio):
            return "qwen2.5-vl-3b-instruct"
        case (.qwen3VL4B, _):
            return "qwen3-vl:4b"
        case (.qwen25VL3B, _):
            return "qwen2.5vl:3b"
        }
    }

    func instructions(for engine: LocalEngine) -> LocalModelInstructionSet {
        switch engine {
        case .ollama, .custom:
            return LocalModelInstructionSet(
                title: "通过Ollama安装",
                subtitle: "在拉取模型之前，请确保您使用的是Ollama 0.12.10或更新版本。",
                bullets: [
                    "打开终端",
                    "运行下面的拉取命令（约5GB下载）",
                    "保持Ollama在后台运行"
                ],
                commandTitle: "运行此命令：",
                commandSubtitle: "为Ollama下载\(displayName)",
                command: ollamaPullCommand,
                buttonTitle: nil,
                buttonURL: nil,
                note: "需要继续使用Qwen2.5？保持选择当前模型并跳过此升级。"
            )
        case .lmstudio:
            return LocalModelInstructionSet(
                title: "在LM Studio中安装",
                subtitle: "请确保您使用的是0.3.31版本。使用LM Studio的模型浏览器下载GGUF版本。",
                bullets: [
                    "打开LM Studio并点击模型选项卡",
                    "搜索\"\(modelId(for: .lmstudio))\"",
                    "下载Instruct版本，然后启动本地服务器"
                ],
                commandTitle: nil,
                commandSubtitle: nil,
                command: nil,
                buttonTitle: "在LM Studio中打开下载",
                buttonURL: lmStudioDownloadURL,
                note: "提示：启用\"启动本地服务器\"，以便Dayflow可以在\(LocalEngine.lmstudio.defaultBaseURL)与LM Studio通信。"
            )
        }
    }

    var ollamaPullCommand: String {
        switch self {
        case .qwen3VL4B: return "ollama pull qwen3-vl:4b"
        case .qwen25VL3B: return "ollama pull qwen2.5vl:3b"
        }
    }

    var lmStudioDownloadURL: URL? {
        switch self {
        case .qwen3VL4B:
            return URL(string: "https://model.lmstudio.ai/download/lmstudio-community/Qwen3-VL-4B-Instruct-GGUF")
        case .qwen25VL3B:
            return URL(string: "https://model.lmstudio.ai/download/lmstudio-community/Qwen2.5-VL-3B-Instruct-GGUF")
        }
    }
}

enum LocalModelPreferences {
    private static let presetKey = "llmLocalModelPreset"
    private static let upgradeDismissedKey = "llmLocalModelUpgradeDismissed"
    private static let defaults = UserDefaults.standard

    static func currentPreset() -> LocalModelPreset? {
        guard let raw = defaults.string(forKey: presetKey) else { return nil }
        return LocalModelPreset(rawValue: raw)
    }

    static func savePreset(_ preset: LocalModelPreset) {
        defaults.set(preset.rawValue, forKey: presetKey)
    }

    static func clearPreset() {
        defaults.removeObject(forKey: presetKey)
    }

    static func syncPreset(for engine: LocalEngine, modelId: String) {
        let normalized = modelId.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !normalized.isEmpty else {
            clearPreset()
            return
        }
        if let preset = LocalModelPreset.allCases.first(where: { $0.modelId(for: engine) == normalized }) {
            savePreset(preset)
        } else {
            clearPreset()
        }
    }

    static func defaultModelId(for engine: LocalEngine) -> String {
        LocalModelPreset.recommended.modelId(for: engine)
    }

    static func shouldShowUpgradeBanner(engine: LocalEngine, modelId: String) -> Bool {
        if defaults.bool(forKey: upgradeDismissedKey) { return false }
        if currentPreset() == .qwen3VL4B { return false }
        let normalized = modelId.trimmingCharacters(in: .whitespacesAndNewlines)
        return normalized == LocalModelPreset.qwen25VL3B.modelId(for: engine)
    }

    static func markUpgradeDismissed(_ dismissed: Bool) {
        defaults.set(dismissed, forKey: upgradeDismissedKey)
    }
}
