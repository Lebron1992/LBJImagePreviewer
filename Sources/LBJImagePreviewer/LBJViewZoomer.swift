import SwiftUI

public struct LBJViewZoomer<Content: View>: View {

  private let contentInfo: (content: Content, aspectRatio: CGFloat)
  private let doubleTapScale: CGFloat
  private let maxScale: CGFloat

  /// 使用 `View` 、宽高比例、双击放大时的倍数和最大放大倍数创建 `LBJViewZoomer`
  /// (Creates an `LBJViewZoomer` view using an `View`, width/height ratio, the zoom scale when user double-tap the view and max scale)。
  /// - Parameters:
  ///   - content: `View` 视图 (an `View`)
  ///   - aspectRatio: `View` 的宽高比例 (the width/height ratio of the `View`)
  ///   - doubleTapScale: 双击放大时的倍数，默认是 3 (the zoom scale when user double-tap the view, 3 by default)
  ///   - maxScale: 最大放大倍数 (max scale, 16 by default)
  public init(
    content: Content,
    aspectRatio: CGFloat,
    doubleTapScale: CGFloat = LBJImagePreviewerConstants.defaultDoubleTapScale,
    maxScale: CGFloat = LBJImagePreviewerConstants.defaultMaxScale
  ) {
    self.contentInfo = (content, aspectRatio)
    self.doubleTapScale = doubleTapScale
    self.maxScale = maxScale
  }

  var resetScaleOnDisappear = true

  @State
  private var steadyStateZoomScale: CGFloat = 1

  @GestureState
  private var gestureZoomScale: CGFloat = 1

  public var body: some View {
    GeometryReader { geometry in
      let zoomedViewSize = zoomedViewSize(in: geometry)
      ScrollView([.vertical, .horizontal]) {
        viewContent
          .gesture(doubleTapGesture())
          .frame(
            width: zoomedViewSize.width,
            height: zoomedViewSize.height
          )
          .padding(.vertical, (max(0, geometry.size.height - zoomedViewSize.height) / 2))
      }
      // Note: Attach the zoom gesture here to fix the issue
      // where the view gets stuck if you attach the gesture to `viewContent` on a real device(works perfectly on a simulator).
      // But the zoome gesture becomes insensitive.
      // This is the temporary solution. Let's wait for Apple's fix.
      .gesture(zoomGesture())
    }
    .onDisappear {
      if resetScaleOnDisappear {
        steadyStateZoomScale = 1
      }
    }
  }
}

// MARK: - Subviews
private extension LBJViewZoomer {
  @ViewBuilder
  var viewContent: some View {
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

  func viewSize(fits geometry: GeometryProxy) -> CGSize {
    let geoRatio = geometry.size.width / geometry.size.height
    let contentRatio = contentInfo.aspectRatio

    let width: CGFloat
    let height: CGFloat
    if contentRatio < geoRatio {
      height = geometry.size.height
      width = height * contentRatio
    } else {
      width = geometry.size.width
      height = width / contentRatio
    }

    return .init(width: width, height: height)
  }

  func zoomedViewSize(in geometry: GeometryProxy) -> CGSize {
    viewSize(fits: geometry) * zoomScale
  }
}

#if DEBUG
struct LBJViewZoomer_Previews: PreviewProvider {
  static var previews: some View {
    let uiImages = (1...2).compactMap { UIImage(named: "IMG_000\($0)", in: .module, with: nil) }
    LBJImagePreviewer(
      content: Image(uiImage: uiImages[0]),
      aspectRatio: uiImages[0].size.width / uiImages[0].size.height
    )
    LBJViewZoomer<MyImage>(
      content: MyImage(image: Image(uiImage: uiImages[1])),
      aspectRatio: uiImages[1].size.width / uiImages[1].size.height
    )
    LBJViewZoomer<Color>(
      content: .red,
      aspectRatio: 1
    )
  }

  struct MyImage: View {
    let image: Image

    var body: some View {
      image
        .resizable()
    }
  }
}
#endif
