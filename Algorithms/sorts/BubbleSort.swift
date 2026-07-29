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
        let start = Date()
        var tempArray = array
        for i in 0..<tempArray.count {
            for j in 0..<(tempArray.count - i - 1) {
                if tempArray[j] > tempArray[j + 1] {
                    tempArray.swapAt(j, j + 1)
                }
            }
        }
        let finish = Date()
        let elapsedTime = finish.timeIntervalSince(start)
        return elapsedTime
    }
    
}
