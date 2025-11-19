import SwiftUI

struct JournalView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("日志")
                .font(.custom("InstrumentSerif-Regular", size: 42))
                .foregroundColor(.black)
                .padding(.leading, 10) // Match Timeline header inset

            // Preview area fills the remaining content space (static image)
            ZStack {
                GeometryReader { geo in
                    Image("JournalPreview")
                        .resizable()
                        .interpolation(.high)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geo.size.width, height: geo.size.height, alignment: .top)
                        .clipped()
                }

                // Centered white rectangle overlay
                VStack(spacing: 10) {
                    Text("此功能正在开发中。如果您想成为第一个测试它的用户，请通过反馈标签联系我们！")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)

                    Text("关于您如何度 过一天的叙述性概述，突出专注时间段、关键应用程序和网站、上下文切换和干扰；非常适合反思或分享。")
                        .font(.system(size: 13))
                        .foregroundColor(Color.black.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 480)
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 14)
                .background(Color.white.opacity(0.96))
                .clipShape(RoundedRectangle(cornerRadius: 2, style: .continuous))
                .shadow(color: Color.black.opacity(0.10), radius: 10, x: 0, y: 6)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}
