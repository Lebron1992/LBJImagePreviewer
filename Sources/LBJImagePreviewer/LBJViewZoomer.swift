import SwiftUI

public struct LBJViewZoomer<ContentView: View>: View {

  private let contentInfo: (content: ContentView, aspectRatio: CGFloat)
  private let doubleTapScale: CGFloat
  private let maxScale: CGFloat

  /// 使用 `UIImage`、双击放大时的倍数和最大放大倍数创建 `LBJViewZoomer`
  /// (Creates an `LBJViewZoomer` view using an `UIImage` object, the zoom scale when user double-tap the image and max scale)。
  /// - Parameters:
  ///   - uiImage: `UIImage` 对象 (an `UIImage` object)
  ///   - doubleTapScale: 双击放大时的倍数，默认是 3 (the zoom scale when user double-tap the image, 3 by default)
  ///   - maxScale: 最大放大倍数 (max scale, 16 by default)
  public init(
    uiImage: UIImage,
    doubleTapScale: CGFloat = LBJImagePreviewerConstants.defaultDoubleTapScale,
    maxScale: CGFloat = LBJImagePreviewerConstants.defaultMaxScale
  ) {
    self.init(
      content: Image(uiImage: uiImage) as! ContentView,
      aspectRatio: uiImage.size.width / uiImage.size.height,
      doubleTapScale: doubleTapScale,
      maxScale: maxScale
    )
  }

  /// 使用 `View` 、宽高比例、双击放大时的倍数和最大放大倍数创建 `LBJViewZoomer`
  /// (Creates an `LBJViewZoomer` view using an `View`, width/height ratio, the zoom scale when user double-tap the image and max scale)。
  /// - Parameters:
  ///   - image: `View` 视图 (an `View`)
  ///   - aspectRatio: `View` 的宽高比例 (the width/height ratio of the `View`)
  ///   - doubleTapScale: 双击放大时的倍数，默认是 3 (the zoom scale when user double-tap the image, 3 by default)
  ///   - maxScale: 最大放大倍数 (max scale, 16 by default)
  public init(
    content: ContentView,
    aspectRatio: CGFloat,
    doubleTapScale: CGFloat = LBJImagePreviewerConstants.defaultDoubleTapScale,
    maxScale: CGFloat = LBJImagePreviewerConstants.defaultMaxScale
  ) {
    self.contentInfo = (content, aspectRatio)
    self.doubleTapScale = doubleTapScale
    self.maxScale = maxScale
  }

  @State
  private var steadyStateZoomScale: CGFloat = 1

  @GestureState
  private var gestureZoomScale: CGFloat = 1

  public var body: some View {
    GeometryReader { geometry in
      let zoomedImageSize = zoomedImageSize(in: geometry)
      ScrollView([.vertical, .horizontal]) {
        imageContent
          .gesture(doubleTapGesture())
          .gesture(zoomGesture())
          .frame(
            width: zoomedImageSize.width,
            height: zoomedImageSize.height
          )
          .padding(.vertical, (max(0, geometry.size.height - zoomedImageSize.height) / 2))
      }
      .background(Color.black)
    }
    .ignoresSafeArea()
  }
}

// MARK: - Subviews
private extension LBJViewZoomer {
  @ViewBuilder
  var imageContent: some View {
    if let image = contentInfo.content as? Image {
      image
        .resizable()
        .aspectRatio(contentMode: .fit)
    } else {
      contentInfo.content
    }
  }
}

// MARK: - Gestures
private extension LBJViewZoomer {

  // MARK: Tap

  func doubleTapGesture() -> some Gesture {
    TapGesture(count: 2)
      .onEnded {
        withAnimation {
          if zoomScale > 1 {
            steadyStateZoomScale = 1
          } else {
            steadyStateZoomScale = doubleTapScale
          }
        }
      }
  }

  // MARK: Zoom

  var zoomScale: CGFloat {
    steadyStateZoomScale * gestureZoomScale
  }

  func zoomGesture() -> some Gesture {
    MagnificationGesture()
      .updating($gestureZoomScale) { latestGestureScale, gestureZoomScale, _ in
        gestureZoomScale = latestGestureScale
      }
      .onEnded { gestureScaleAtEnd in
        steadyStateZoomScale *= gestureScaleAtEnd
        makeSureZoomScaleInBounds()
      }
  }

  func makeSureZoomScaleInBounds() {
    withAnimation {
      if steadyStateZoomScale < 1 {
        steadyStateZoomScale = 1
        Haptics.impact(.light)
      } else if steadyStateZoomScale > maxScale {
        steadyStateZoomScale = maxScale
        Haptics.impact(.light)
      }
    }
  }
}

// MARK: - Helper Methods
private extension LBJViewZoomer {

  func imageSize(fits geometry: GeometryProxy) -> CGSize {
    let geoRatio = geometry.size.width / geometry.size.height
    let imageRatio = contentInfo.aspectRatio

    let width: CGFloat
    let height: CGFloat
    if imageRatio < geoRatio {
      height = geometry.size.height
      width = height * imageRatio
    } else {
      width = geometry.size.width
      height = width / imageRatio
    }

    return .init(width: width, height: height)
  }

  func zoomedImageSize(in geometry: GeometryProxy) -> CGSize {
    imageSize(fits: geometry) * zoomScale
  }
}

public enum LBJImagePreviewerConstants {
  public static let defaultDoubleTapScale: CGFloat = 3
  public static let defaultMaxScale: CGFloat = 16
}

#if DEBUG
struct LBJImagePreviewer_Previews: PreviewProvider {

  struct MyImage: View {
    let image: Image

    var body: some View {
      image.resizable()
    }
  }

  static var previews: some View {
    let uiImages = (1...3).compactMap { UIImage(named: "IMG_000\($0)", in: .module, with: nil) }
    LBJUIImagePreviewer(uiImage: uiImages[0])
    LBJImagePreviewer(
      content: Image(uiImage: uiImages[1]),
      aspectRatio: uiImages[1].size.width / uiImages[1].size.height
    )
    LBJViewZoomer<MyImage>(
      content: MyImage(image: Image(uiImage: uiImages[2])),
      aspectRatio: uiImages[2].size.width / uiImages[2].size.height
    )
    LBJViewZoomer<Color>(
      content: .red,
      aspectRatio: 1
    )
  }
}
#endif
