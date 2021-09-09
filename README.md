# LBJImagePreviewer

[English Readme](./README_en.md)

`LBJImagePreviewer` 是一个在 SwiftUI 框架下实现的图片预览器。

## 特性

- 手势缩放和滚动
- 双击放大缩小

## 安装

使用 Swift Package Manager 安装：

1. 复制库的路径

```
https://github.com/Lebron1992/LBJImagePreviewer
```

2. 在 Xcode 中打开菜单 `File / Add Packages`
3. 把路径粘贴到搜索框，根据提示把库添加到项目中

## 使用

你可以使用 `UIImage` 或 `Image` 创建 `LBJImagePreviewer`：

```swift
let uiImage = UIImage(named: "lebron")!

// 使用 `UIImage`
LBJImagePreviewer(uiImage: uiImage)

// 使用 `Image`，需要传入 `Image` 的宽高比
LBJImagePreviewer(image: Image(uiImage: uiImage), aspectRatio: 2 / 3)
```

### 指定最大放大倍数

另外还提供了 `maxScale`，用于指定最大放大倍数，默认值是 `3`：

```swift
LBJImagePreviewer(uiImage: uiImage, maxScale: 5)
LBJImagePreviewer(image: Image(uiImage: uiImage), aspectRatio: 2 / 3, maxScale: 5)
```

## 存在问题

- 双击放大时，图片只能从中间位置放大，无法在点击位置放大。（目前 `ScrollView` 无法手动设置 `contentOffset`，等待 `ScrollView` 更新以解决这个问题。）

## 请求添加新功能

请使用 GitHub issues。
