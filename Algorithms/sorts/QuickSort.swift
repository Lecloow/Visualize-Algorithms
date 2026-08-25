//
//  QuickSort.swift
//  Algorithms
//
//  Created by Thomas Conchon on 7/9/26.
//

import Foundation

struct QuickSort: SortingAlgorithm {

    let name = "Quick Sort"

    /// Creates a stream of steps that visualizes sorting the array with quicksort.
    /// - Parameter array: The values to sort.
    /// - Returns: A stream of comparison, swap, and sorted-position steps.
    func generateSteps(from array: [Int]) -> AsyncStream<SortStep> {
        AsyncStream { continuation in
            var tempArray = array
            func quickSort(low: Int, high: Int) {
                guard low < high else {
                    if low == high {
                        continuation.yield(.markSorted(low))
                    }
                    return
                }
                let pivot = tempArray[high]
                var i = low
                for j in low..<high {
                    continuation.yield(.compare(j, high))
                    if tempArray[j] < pivot {
                        if i != j {
                            tempArray.swapAt(i, j)
                            continuation.yield(.swap(i, j))
                        }
                        i += 1
                    }
                }
                if i != high {
                    tempArray.swapAt(i, high)
                    continuation.yield(.swap(i, high))
                }
                continuation.yield(.markSorted(i))
                quickSort(low: low, high: i - 1)
                quickSort(low: i + 1, high: high)
            }
            quickSort(low: 0, high: tempArray.count - 1)
            continuation.finish()
        }
    }
    
    /// Sorts a copy of the provided array and measures the sorting duration.
    /// - Parameter array: The integer array to sort.
    /// - Returns: The elapsed sorting time in seconds.
    nonisolated func sort(_ array: [Int]) -> TimeInterval {
        let start = DispatchTime.now().uptimeNanoseconds
        var tempArray = array
        func quickSort(low: Int, high: Int) {
            guard low < high else { return }
            let pivot = tempArray[high]
            var i = low
            for j in low..<high {
                if tempArray[j] < pivot {
                    if i != j {
                        tempArray.swapAt(i, j)
                    }
                    i += 1
                }
            }
            if i != high {
                tempArray.swapAt(i, high)
            }
            quickSort(low: low, high: i - 1)
            quickSort(low: i + 1, high: high)
        }
        quickSort(low: 0, high: tempArray.count - 1)
        let end = DispatchTime.now().uptimeNanoseconds
        return Double(end - start) / 1_000_000_000
    }
    
}
