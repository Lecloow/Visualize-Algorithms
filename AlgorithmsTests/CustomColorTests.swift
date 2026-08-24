import XCTest
@testable import Algorithms

final class CustomColorTests: XCTestCase {
    func testEveryCaseHasTriColorPalette() {
        let cases: [CustomColor] = [.blue, .gray, .green, .orange, .pink, .purple, .red, .black]
        for color in cases {
            XCTAssertFalse(color.background.isEmpty, "\(color) is missing a background hex")
            XCTAssertFalse(color.foreground.isEmpty, "\(color) is missing a foreground hex")
            XCTAssertFalse(color.neutral.isEmpty, "\(color) is missing a neutral hex")
        }
    }

    func testBackgroundHexValues() {
        XCTAssertEqual(CustomColor.blue.background, "#c1def5")
        XCTAssertEqual(CustomColor.green.background, "#cfe1d6")
        XCTAssertEqual(CustomColor.red.background, "#f5d1cd")
        XCTAssertEqual(CustomColor.black.background, "#000000")
    }

    func testForegroundHexValues() {
        XCTAssertEqual(CustomColor.blue.foreground, "#264a72")
        XCTAssertEqual(CustomColor.green.foreground, "#2a533c")
        XCTAssertEqual(CustomColor.red.foreground, "#6d3531")
        XCTAssertEqual(CustomColor.black.foreground, "#000000")
    }

    func testNeutralHexValues() {
        XCTAssertEqual(CustomColor.blue.neutral, "#2783de")
        XCTAssertEqual(CustomColor.green.neutral, "#46a171")
        XCTAssertEqual(CustomColor.red.neutral, "#e56458")
        XCTAssertEqual(CustomColor.black.neutral, "#000000")
    }

    func testAppColorResolvesAllRoles() {
        let appColor = CustomColor.blue.appColor
        XCTAssertNotEqual(appColor.background, appColor.foreground)
        XCTAssertNotEqual(appColor.neutral, appColor.background)
    }

    func testBlackKeepsLightBackgroundCompatibility() {
        // `.black` intentionally renders as white background with black text.
        let black = CustomColor.black.appColor
        XCTAssertEqual(black.foreground, .black)
    }
}
