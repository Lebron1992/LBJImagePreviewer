import SwiftUI

public struct LBJGIFImagePreviewer: View {

  private let imageData: Data?
  private let doubleTapScale: CGFloat
  private let maxScale: CGFloat

  /// 使用 `Data`、双击放大时的倍数和最大放大倍数创建 `LBJGIFImagePreviewer`
  /// (Creates an `LBJGIFImagePreviewer` view using the gif image data, the zoom scale when user double-tap the image and max scale)。
  /// - Parameters:
  ///   - imageData: gif 图片数据。The gif image data.
  ///   - doubleTapScale: 双击放大时的倍数，默认是 3 (the zoom scale when user double-tap the image, 3 by default)
  ///   - maxScale: 最大放大倍数 (max scale, 16 by default)
  public init(
    imageData: Data,
    doubleTapScale: CGFloat = LBJImagePreviewerConstants.defaultDoubleTapScale,
    maxScale: CGFloat = LBJImagePreviewerConstants.defaultMaxScale
  ) {
    self.imageData = imageData
    self.doubleTapScale = doubleTapScale
    self.maxScale = maxScale
  }

  /// 使用 gif 图片名字、图片所在的 `Bundle`、双击放大时的倍数和最大放大倍数创建 `LBJGIFImagePreviewer`
  /// (Creates an `LBJGIFImagePreviewer` view using the name of gif image, the bundle where the gif image in, the zoom scale when user double-tap the image and max scale)。
  /// - Parameters:
  ///   - name: gif 图片名字。The name of gif image。
  ///   - bundle: 图片所在的 `Bundle`。The bundle where the gif image in.
  ///   - doubleTapScale: 双击放大时的倍数，默认是 3 (the zoom scale when user double-tap the image, 3 by default)
  ///   - maxScale: 最大放大倍数 (max scale, 16 by default)
  public init(
    imageNamed name: String,
    in bundle: Bundle = .main,
    doubleTapScale: CGFloat = LBJImagePreviewerConstants.defaultDoubleTapScale,
    maxScale: CGFloat = LBJImagePreviewerConstants.defaultMaxScale
  ) {
    do {
      if let url = bundle.url(forResource: name, withExtension: "gif") {
        self.imageData = try Data(contentsOf: url)
      } else {
        throw "Can't find \(name).gif in bundle"
      }
    } catch {
      self.imageData = nil
      print("[LBJImagePreviewer.LBJGIFImagePreviewer] failed to get data from \(name).gif in \(bundle): \(error.localizedDescription)")
    }

    self.doubleTapScale = doubleTapScale
    self.maxScale = maxScale
  }

  var resetScaleOnDisappear = true

  public var body: some View {
    if let imageData = imageData {
      var aspectRatio: CGFloat = 1
      if let imageSize = UIImage(data: imageData)?.size {
        aspectRatio = imageSize.width / imageSize.height
      }
      return GeometryReader { geometry in
        LBJViewZoomer(
          content: GifImageView(imageData: imageData, geometry: geometry),
          aspectRatio: aspectRatio,
          doubleTapScale: doubleTapScale,
          maxScale: maxScale
        )
          .resetScaleOnDisappear(resetScaleOnDisappear)
      }
      .asAnyView()
    } else {
      return EmptyView().asAnyView()
    }
  }
}

#if DEBUG
struct LBJGIFImagePreviewer_Previews: PreviewProvider {
  static var previews: some View {
    LBJGIFImagePreviewer(imageNamed: "lebron", in: .module)

    if let url = Bundle.module.url(forResource: "lebron", withExtension: "gif"),
       let data = try? Data(contentsOf: url) {
      LBJGIFImagePreviewer(imageData: data)
    }
  }
}
#endif
