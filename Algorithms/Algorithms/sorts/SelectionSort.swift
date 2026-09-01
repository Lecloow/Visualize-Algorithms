//
//  SelectionSort.swift
//  Algorithms
//
//  Created by Thomas Conchon on 7/9/26.
//

import Foundation

struct SelectionSort: SortingAlgorithm {

    let name = "Selection Sort"

    /// Generates the sorting steps for the provided array using selection sort.
    /// - Parameter array: The array to sort.
    /// - Returns: A stream of comparison, swap, and sorted-position steps.
    func generateSteps(from array: [Int]) -> AsyncStream<SortStep> {
        AsyncStream { continuation in
            var tempArray = array
            for i in 0..<tempArray.count {
                var minIndex = i
                for j in (i + 1)..<tempArray.count {
                    continuation.yield(.compare(minIndex, j))
                    if tempArray[j] < tempArray[minIndex] {
                        minIndex = j
                    }
                }
                if minIndex != i {
                    tempArray.swapAt(i, minIndex)
                    continuation.yield(.swap(i, minIndex))
                }
                continuation.yield(.markSorted(i))
            }
            continuation.finish()
        }
    }
    
    /// Sorts a copy of the array using selection sort and measures the elapsed time.
    /// - Parameter array: The array to sort.
    /// - Returns: The sorting duration in seconds.
    nonisolated func sort(_ array: [Int]) -> TimeInterval {
        let start = DispatchTime.now().uptimeNanoseconds
        var tempArray = array
        for i in 0..<tempArray.count {
            var minIndex = i
            for j in (i + 1)..<tempArray.count {
                if tempArray[j] < tempArray[minIndex] {
                    minIndex = j
                }
            }
            if minIndex != i {
                tempArray.swapAt(i, minIndex)
            }
        }
        let end = DispatchTime.now().uptimeNanoseconds
        return Double(end - start) / 1_000_000_000
    }
    
}
