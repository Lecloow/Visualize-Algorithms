//
//  BubbleSort.swift
//  Algorithms
//
//  Created by Thomas Conchon on 7/9/26.
//

import Foundation

struct BubbleSort: SortingAlgorithm {

    let name = "Bubble Sort"

    func generateSteps(from array: [Int]) -> AsyncStream<SortStep> {
        AsyncStream { continuation in
            var tempArray = array
            for i in 0..<tempArray.count {
                for j in 0..<(tempArray.count - i - 1) {
                    continuation.yield(.compare(j, j + 1))
                    if tempArray[j] > tempArray[j + 1] {
                        tempArray.swapAt(j, j + 1)
                        continuation.yield(.swap(j, j + 1))
                    }
                }
                continuation.yield(.markSorted(tempArray.count - i - 1))
            }
            continuation.finish()
        }
    }
    
    func sort(_ array: [Int]) -> TimeInterval {
        let start = DispatchTime.now().uptimeNanoseconds
        var tempArray = array
        for i in 0..<tempArray.count {
            for j in 0..<(tempArray.count - i - 1) {
                if tempArray[j] > tempArray[j + 1] {
                    tempArray.swapAt(j, j + 1)
                }
            }
        }
        let end = DispatchTime.now().uptimeNanoseconds
        return Double(end - start) / 1_000_000_000
    }
    
}
