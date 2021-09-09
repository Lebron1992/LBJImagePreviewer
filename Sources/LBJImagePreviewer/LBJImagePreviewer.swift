import SwiftUI

public struct LBJImagePreviewer: View {

  private let uiImage: UIImage?
  private let imageInfo: (image: Image, aspectRatio: CGFloat)?
  private let maxScale: CGFloat

  public init(uiImage: UIImage, maxScale: CGFloat = Constant.defaultMaxScale) {
    self.uiImage = uiImage
    self.imageInfo = nil
    self.maxScale = maxScale
  }

  public init(image: Image, aspectRatio: CGFloat, maxScale: CGFloat = Constant.defaultMaxScale) {
    self.uiImage = nil
    self.imageInfo = (image, aspectRatio)
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
private extension LBJImagePreviewer {
  @ViewBuilder
  var imageContent: some View {
    if let uiImage = uiImage {
      Image(uiImage: uiImage)
        .resizable()
        .aspectRatio(contentMode: .fit)
    } else if let image = imageInfo?.image {
      image.resizable()
    }
  }
}

// MARK: - Gestures
private extension LBJImagePreviewer {

  // MARK: Tap

  func doubleTapGesture() -> some Gesture {
    TapGesture(count: 2)
      .onEnded {
        withAnimation {
          if zoomScale > 1 {
            steadyStateZoomScale = 1
          } else {
            steadyStateZoomScale = maxScale
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
private extension LBJImagePreviewer {
  func imageSize(fits geometry: GeometryProxy) -> CGSize {
    if let uiImage = uiImage {
      let hZoom = geometry.size.width / uiImage.size.width
      let vZoom = geometry.size.height / uiImage.size.height
      return uiImage.size * min(hZoom, vZoom)

    } else if let imageInfo = imageInfo {
      let geoRatio = geometry.size.width / geometry.size.height
      let imageRatio = imageInfo.aspectRatio

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

    } else {
      fatalError("you must provide a UIImage or Image")
    }
  }

  func zoomedImageSize(in geometry: GeometryProxy) -> CGSize {
    imageSize(fits: geometry) * zoomScale * zoomScale
  }
}

public extension LBJImagePreviewer {
  enum Constant {
    public static let defaultMaxScale: CGFloat = 3
  }
}

#if DEBUG
struct LBJImagePreviewer_Previews: PreviewProvider {
  static var previews: some View {
    let uiImages = (1...3).compactMap { UIImage(named: "IMG_000\($0)", in: .module, with: nil)}
    LBJImagePreviewer(uiImage: uiImages[0])
    LBJImagePreviewer(image: Image(uiImage: uiImages[1]), aspectRatio: uiImages[1].size.width / uiImages[1].size.height)
    LBJImagePreviewer(image: Image(uiImage: uiImages[2]), aspectRatio: uiImages[2].size.width / uiImages[2].size.height)
  }
}
#endif
