import Foundation

/// 以 _Builder_ 的模式添加一个方法用于修改属性
protocol Buildable { }

extension Buildable {
    /// 修改属性
    ///
    /// - Parameter keyPath: 属性的 `WritableKeyPath`
    /// - Parameter value: 新的属性值
    func mutating<T>(keyPath: WritableKeyPath<Self, T>, value: T) -> Self {
        var newSelf = self
        newSelf[keyPath: keyPath] = value
        return newSelf
    }
}
