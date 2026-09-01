import XCTest
@testable import Algorithms

@MainActor
final class BenchmarkTests: XCTestCase {
    func testBenchmarkPublishesOneResultPerSelectedAlgorithm() async {
        let viewModel = AlgorithmsViewModel()
        viewModel.selection = Set(viewModel.algorithms
            .filter {
                if case .sorting = $0.type { return true }
                return false
            }
            .prefix(2)
            .map(\.id))
        viewModel.sortViewModel.sortState.length = 100

        await viewModel.startBenchmark()

        XCTAssertFalse(viewModel.sortViewModel.sortState.isSorting)
        XCTAssertEqual(
            viewModel.sortViewModel.sortState.benchmarkResults.count,
            viewModel.selection.count
        )
        XCTAssertTrue(viewModel.sortViewModel.sortState.benchmarkResults.allSatisfy { $0.elapsedTime >= 0 })
    }

    func testBenchmarkClampsInvalidLength() async {
        let viewModel = AlgorithmsViewModel()
        viewModel.selection = [viewModel.algorithms[0].id]
        viewModel.sortViewModel.sortState.length = 0

        await viewModel.startBenchmark()

        XCTAssertEqual(viewModel.sortViewModel.sortState.benchmarkResults.count, 1)
    }
}