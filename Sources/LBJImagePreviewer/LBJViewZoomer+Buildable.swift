import Foundation

extension LBJViewZoomer: Buildable {
  /// 设置当消失时是否重置放大倍数 (Sets `LBJViewZoomer` wheather reset the scale on disappear)
  /// - Parameter value: 是否重置，默认是 `true` (`true` if  should reset, `true` by default)
  public func resetScaleOnDisappear(_ value: Bool = true) -> Self {
    mutating(keyPath: \.resetScaleOnDisappear, value: value)
  }
}
