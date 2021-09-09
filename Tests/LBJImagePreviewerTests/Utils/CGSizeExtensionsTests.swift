import XCTest
@testable import LBJImagePreviewer

final class MediaViewerTests: XCTestCase {
  func test_multiply() {
    let size = CGSize(width: 10, height: 15)
    XCTAssertEqual(size * 2, .init(width: 20, height: 30))
    XCTAssertEqual(size * 3, .init(width: 30, height: 45))
  }
}
