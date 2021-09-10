# LBJImagePreviewer

[English Readme](./README_en.md)

`LBJImagePreviewer` 是一个在 SwiftUI 框架下实现的图片预览器。

## 特性

- 手势缩放和滚动
- 双击放大缩小

### 预览

![preview](./preview.gif)

## 安装

使用 Swift Package Manager 安装：

1. 复制库的路径

```
https://github.com/Lebron1992/LBJImagePreviewer
```

2. 在 Xcode 中打开菜单 `File / Add Packages`
3. 把路径粘贴到搜索框，根据提示把库添加到项目中

## 使用

### `UIImage`

预览 `UIImage`：

```swift
let uiImage = UIImage(named: "lebron")!
LBJUIImagePreviewer(uiImage: uiImage)
```

### `Image`

预览 `Image`：

```swift
// 需要传入 `Image` 的宽高比
LBJImagePreviewer(content: Image(uiImage: uiImage), aspectRatio: 2 / 3)
```

### 任意 `View`

如果你不是直接通过 `UIImage` 或者 `Image` 来显示图片，你可以预览任意 `View`。例如预览一个红色背景：

```swift
LBJViewZoomer<Color>(content: .red, aspectRatio: 1)
```

### 指定双击时的放大倍数

指定当用户双击图片时的放大倍数，默认是 `3`：

```swift
LBJUIImagePreviewer(uiImage: uiImage, doubleTapScale: 5)
LBJImagePreviewer(content: Image(uiImage: uiImage), aspectRatio: 2 / 3, doubleTapScale: 5)
```

### 指定最大放大倍数

指定最大放大倍数，默认是 `16`：

```swift
LBJUIImagePreviewer(uiImage: uiImage, maxScale: 20)
LBJImagePreviewer(content: Image(uiImage: uiImage), aspectRatio: 2 / 3, maxScale: 20)
```

## 存在问题

- 双击放大时，图片只能从中间位置放大，无法在点击位置放大。（目前 `ScrollView` 无法手动设置 `contentOffset`，等待 `ScrollView` 更新以解决这个问题。）

## 请求添加新功能

请使用 GitHub issues。
