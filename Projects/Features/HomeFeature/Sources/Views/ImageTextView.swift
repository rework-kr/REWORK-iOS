import SwiftUI
import DesignSystem
import Utility

public struct ImageTextView: View {
    let subTitle: String
    let Title: String
    
    private init(subTitle: String, Title: String) {
        self.subTitle = subTitle
        self.Title = Title
    }
    
    public var body: some View {
        HStack(alignment: .center, spacing: 10) {
            DesignSystemAsset.Home.bookRoundedRectangle.swiftUIImage
                .resizable()
                .frame(width: 40, height: 40)
            VStack(alignment: .leading, spacing: 2) {
                Text(subTitle)
                    .font(DesignSystemFontFamily.Pretendard.medium.swiftUIFont(size: 10))
                    .foregroundStyle(Color.gray)
                    
                Text(Title)
                    .font(DesignSystemFontFamily.Pretendard.bold.swiftUIFont(size: 14))
                    .foregroundStyle(Color.black)
            }
        }
    }
    
    public static func makeUIView(subTitle: String, title: String) -> UIView {
        let hostingController = UIHostingController(rootView: ImageTextView(subTitle: subTitle, Title: title))
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        return hostingController.view
    }
}
