//
//  MergeSort.swift
//  Algorithms
//
//  Created by Thomas Conchon on 7/9/26.
//

import Foundation

struct MergeSort: SortingAlgorithm {

    let name = "Merge Sort"

    /// Generates the merge sort steps for an array.
    /// - Parameter array: The array to sort.
    /// - Returns: A stream of comparison, overwrite, and sorted-marker steps.
    func generateSteps(from array: [Int]) -> AsyncStream<SortStep> {
        AsyncStream { continuation in
            var tempArray = array
            var scratch = array
            func mergeSort(low: Int, high: Int) {
                guard low < high else { return }
                let mid = (low + high) / 2
                mergeSort(low: low, high: mid)
                mergeSort(low: mid + 1, high: high)
                merge(low: low, mid: mid, high: high, temp: &tempArray, scratch: &scratch, continuation)
            }
            mergeSort(low: 0, high: tempArray.count - 1)
            for i in 0..<tempArray.count {
                continuation.yield(.markSorted(i))
            }
            continuation.finish()
        }
    }

    /// Merges two sorted subranges into the specified array while emitting sorting steps.
    /// - Parameters:
    ///   - low: The first index of the range to merge.
    ///   - mid: The last index of the left sorted subrange.
    ///   - high: The last index of the range to merge.
    ///   - temp: The array receiving the merged values.
    ///   - scratch: Temporary storage for the values being merged.
    ///   - continuation: The stream continuation receiving comparison and overwrite steps.
    private func merge(
        low: Int,
        mid: Int,
        high: Int,
        temp: inout [Int],
        scratch: inout [Int],
        _ continuation: AsyncStream<SortStep>.Continuation
    ) {
        for i in low...high {
            scratch[i] = temp[i]
        }
        var left = low
        var right = mid + 1
        var i = low
        while left <= mid && right <= high {
            continuation.yield(.compare(left, right))
            if scratch[left] <= scratch[right] {
                temp[i] = scratch[left]
                left += 1
            } else {
                temp[i] = scratch[right]
                right += 1
            }
            continuation.yield(.overwrite(i, temp[i]))
            i += 1
        }
        while left <= mid {
            temp[i] = scratch[left]
            continuation.yield(.overwrite(i, temp[i]))
            left += 1
            i += 1
        }
        while right <= high {
            temp[i] = scratch[right]
            continuation.yield(.overwrite(i, temp[i]))
            right += 1
            i += 1
        }
    }
    
    /// Measures the time required to sort an integer array using merge sort.
    /// - Returns: The elapsed sorting time in seconds.
    nonisolated func sort(_ array: [Int]) -> TimeInterval {
        let start = DispatchTime.now().uptimeNanoseconds
        var tempArray = array
        var scratch = array
        func mergeSort(low: Int, high: Int) {
            guard low < high else { return }
            let mid = (low + high) / 2
            mergeSort(low: low, high: mid)
            mergeSort(low: mid + 1, high: high)
            merge(low: low, mid: mid, high: high, temp: &tempArray, scratch: &scratch)
        }
        mergeSort(low: 0, high: tempArray.count - 1)
        let end = DispatchTime.now().uptimeNanoseconds
        return Double(end - start) / 1_000_000_000
    }

    /// Merges two sorted ranges into the temporary array.
    /// - Parameters:
    ///   - low: The first index of the range to merge.
    ///   - mid: The final index of the left sorted range.
    ///   - high: The final index of the range to merge.
    ///   - temp: The array receiving the merged values.
    ///   - scratch: The buffer containing the values being merged.
    private nonisolated func merge(
        low: Int,
        mid: Int,
        high: Int,
        temp: inout [Int],
        scratch: inout [Int]
    ) {
        for i in low...high {
            scratch[i] = temp[i]
        }
        var left = low
        var right = mid + 1
        var i = low
        while left <= mid && right <= high {
            if scratch[left] <= scratch[right] {
                temp[i] = scratch[left]
                left += 1
            } else {
                temp[i] = scratch[right]
                right += 1
            }
            i += 1
        }
        while left <= mid {
            temp[i] = scratch[left]
            left += 1
            i += 1
        }
        while right <= high {
            temp[i] = scratch[right]
            right += 1
            i += 1
        }
    }
    
}
