import SwiftUI
import UIKit

struct GifImageView: UIViewRepresentable {

  private let imageData: Data?
  private let contentMode: UIView.ContentMode
  private let size: CGSize?

  init(
    imageData: Data,
    contentMode: UIView.ContentMode = .scaleAspectFit,
    size: CGSize? = nil,
    geometry: GeometryProxy
  ) {
    self.init(data: imageData, contentMode: contentMode, size: size, geometry: geometry)
  }

  init(
    imageNamed name: String,
    in bundle: Bundle = .main,
    contentMode: UIView.ContentMode = .scaleAspectFit,
    size: CGSize? = nil,
    geometry: GeometryProxy
  ) {
    var imageData: Data?
    do {
      if let url = bundle.url(forResource: name, withExtension: "gif") {
        imageData = try Data(contentsOf: url)
      } else {
        throw "Can't find \(name).gif in bundle"
      }
    } catch {
      print("[LBJImagePreviewer.GifImageView] failed to get data from \(name).gif in \(bundle): \(error.localizedDescription)")
    }
    self.init(data: imageData, contentMode: contentMode, size: size, geometry: geometry)
  }

  private init(
    data: Data?,
    contentMode: UIView.ContentMode = .scaleAspectFit,
    size: CGSize? = nil,
    geometry: GeometryProxy
  ) {
    self.imageData = data
    self.contentMode = contentMode

    if let size = size {
      self.size = size
    } else if let data = imageData, let imageSize = UIImage(data: data)?.size {
      let width = geometry.size.width
      let height = width * (imageSize.height / imageSize.width)
      self.size = .init(width: width, height: height)
    } else {
      self.size = nil
    }
  }

  func makeUIView(context: Context) -> MyImageView {
    let imageView = MyImageView()
    imageView.contentMode = contentMode
    if let frame = frame {
      imageView.frame = frame
    }
    return imageView
  }

  func updateUIView(_ uiView: MyImageView, context: Context) {
    if let frame = frame {
      uiView.frame = frame
    }
    if let data = imageData {
      CGAnimateImageDataWithBlock(data as CFData, nil) { _, cgImage, _ in
        uiView.image = UIImage(cgImage: cgImage)
      }
    }
  }

  private var frame: CGRect? {
    if let size = size {
      return .init(origin: .zero, size: size)
    }
    return nil
  }

  class MyImageView: UIImageView {
    override var intrinsicContentSize: CGSize {
      frame.size
    }
  }
}
