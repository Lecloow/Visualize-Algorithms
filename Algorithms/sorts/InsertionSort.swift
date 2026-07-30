//
//  InsertionSort.swift
//  Algorithms
//
//  Created by Thomas Conchon on 7/9/26.
//

import Foundation

struct InsertionSort: SortingAlgorithm {

    let name = "Insertion Sort"

    func generateSteps(from array: [Int]) -> AsyncStream<SortStep> {
        AsyncStream { continuation in
            var tempArray = array
            for i in 1..<tempArray.count {
                let key = tempArray[i]
                var j = i-1
                while j >= 0 && tempArray[j] > key {
                    continuation.yield(.compare(j, j+1))
                    tempArray[j + 1] = tempArray[j]
                    continuation.yield(.overwrite(j + 1, tempArray[j + 1]))

                    j -= 1
                }
                tempArray[j + 1] = key
                continuation.yield(.overwrite(j + 1, key))
                continuation.yield(.markSorted(i))
            }
            continuation.yield(.markSorted(0))
            continuation.finish()
        }
    }
    
    func sort(_ array: [Int]) -> TimeInterval {
        let start = DispatchTime.now().uptimeNanoseconds
        var tempArray = array
        for i in 1..<tempArray.count {
            let key = tempArray[i]
            var j = i-1
            while j >= 0 && tempArray[j] > key {
                tempArray[j + 1] = tempArray[j]
                j -= 1
            }
            tempArray[j + 1] = key
        }
        let end = DispatchTime.now().uptimeNanoseconds
        return Double(end - start) / 1_000_000_000
    }
    
}

struct ImprovedInsertionSort: SortingAlgorithm {

    let name = "Improved Insertion Sort"

    func generateSteps(from array: [Int]) -> AsyncStream<SortStep> {
            AsyncStream { continuation in
                var tempArray = array
                for i in 1..<tempArray.count {
                    let key = tempArray[i]

                    var low = 0
                    var high = i - 1
                    while low <= high {
                        let mid = low + (high - low) / 2
                        continuation.yield(.compare(mid, i))
                        if tempArray[mid] < key {
                            low = mid + 1
                        } else {
                            high = mid - 1
                        }
                    }

                    var j = i - 1
                    while j >= low {
                        continuation.yield(.compare(j, j + 1))
                        tempArray[j + 1] = tempArray[j]
                        continuation.yield(.overwrite(j + 1, tempArray[j + 1]))
                        j -= 1
                    }

                    tempArray[low] = key
                    continuation.yield(.overwrite(low, key))
                    continuation.yield(.markSorted(i))
                }

                continuation.yield(.markSorted(0))
                continuation.finish()
            }
        }
    
    func sort(_ array: [Int]) -> TimeInterval {
        let start = DispatchTime.now().uptimeNanoseconds
        var tempArray = array
        for i in 1..<tempArray.count {
            let key = tempArray[i]
            var low = 0
            var high = i - 1

            while low <= high {
                let mid = low + (high - low) / 2
                if tempArray[mid] < key {
                    low = mid + 1
                } else {
                    high = mid - 1
                }
            }

            var j = i - 1
            while j >= low {
                tempArray[j + 1] = tempArray[j]
                j -= 1
            }
            tempArray[low] = key
        }
        let end = DispatchTime.now().uptimeNanoseconds
        return Double(end - start) / 1_000_000_000
    }
}
