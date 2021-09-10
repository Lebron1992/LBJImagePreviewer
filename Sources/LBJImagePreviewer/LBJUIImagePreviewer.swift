import SwiftUI

public struct LBJUIImagePreviewer: View {

  private let uiImage: UIImage
  private let doubleTapScale: CGFloat
  private let maxScale: CGFloat

  /// 使用 `UIImage`、双击放大时的倍数和最大放大倍数创建 `LBJUIImagePreviewer`
  /// (Creates an `LBJUIImagePreviewer` view using an `UIImage` object, the zoom scale when user double-tap the image and max scale)。
  /// - Parameters:
  ///   - uiImage: `UIImage` 对象 (an `UIImage` object)
  ///   - doubleTapScale: 双击放大时的倍数，默认是 3 (the zoom scale when user double-tap the image, 3 by default)
  ///   - maxScale: 最大放大倍数 (max scale, 16 by default)
  public init(
    uiImage: UIImage,
    doubleTapScale: CGFloat = LBJImagePreviewerConstants.defaultDoubleTapScale,
    maxScale: CGFloat = LBJImagePreviewerConstants.defaultMaxScale
  ) {
    self.uiImage = uiImage
    self.doubleTapScale = doubleTapScale
    self.maxScale = maxScale
  }

  public var body: some View {
    LBJViewZoomer(
      content: Image(uiImage: uiImage),
      aspectRatio: uiImage.size.width / uiImage.size.height,
      doubleTapScale: doubleTapScale,
      maxScale: maxScale
    )
  }
}

#if DEBUG
struct LBJUIImagePreviewer_Previews: PreviewProvider {
  static var previews: some View {
    let uiImage = UIImage(named: "IMG_0001", in: .module, with: nil)!
    LBJUIImagePreviewer(uiImage: uiImage)
  }
}
#endif
