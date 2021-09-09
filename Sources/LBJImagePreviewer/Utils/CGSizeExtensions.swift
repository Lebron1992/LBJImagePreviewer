import CoreGraphics

extension CGSize {
  static func * (lhs: Self, rhs: CGFloat) -> CGSize {
    CGSize(width: lhs.width * rhs, height: lhs.height * rhs)
  }
}
