import XCTest
@testable import Algorithms

final class CustomColorTests: XCTestCase {
    func testParsesThreeDigitRGB() {
        XCTAssertEqual(CustomColor.rgba(fromHex: "#F80")?.r, 255)
        XCTAssertEqual(CustomColor.rgba(fromHex: "#F80")?.g, 136)
        XCTAssertEqual(CustomColor.rgba(fromHex: "#F80")?.b, 0)
        XCTAssertEqual(CustomColor.rgba(fromHex: "#F80")?.a, 255)
    }

    func testParsesSixDigitRGB() {
        XCTAssertEqual(CustomColor.rgba(fromHex: "FF8800")?.r, 255)
        XCTAssertEqual(CustomColor.rgba(fromHex: "FF8800")?.g, 136)
        XCTAssertEqual(CustomColor.rgba(fromHex: "FF8800")?.b, 0)
        XCTAssertEqual(CustomColor.rgba(fromHex: "FF8800")?.a, 255)
    }

    func testParsesEightDigitARGB() {
        XCTAssertEqual(CustomColor.rgba(fromHex: "8044CC22")?.r, 68)
        XCTAssertEqual(CustomColor.rgba(fromHex: "8044CC22")?.g, 204)
        XCTAssertEqual(CustomColor.rgba(fromHex: "8044CC22")?.b, 34)
        XCTAssertEqual(CustomColor.rgba(fromHex: "8044CC22")?.a, 128)
    }

    func testRejectsMalformedHex() {
        XCTAssertNil(CustomColor.rgba(fromHex: "GGGGGG"))
        XCTAssertNil(CustomColor.rgba(fromHex: "FF00GG"))
        XCTAssertNil(CustomColor.rgba(fromHex: "12345"))
        XCTAssertNil(CustomColor.rgba(fromHex: "123456789"))
    }

}
