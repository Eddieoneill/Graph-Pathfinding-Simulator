//
//  GraphSearchOptions.swift
//  Graph-Path-Finding
//
//  Created by Edward O'Neill on 2/24/21.
//

import Foundation

enum GraphState {
    case dfs
    case bfs
    case greedy
}

class GraphSearchOptions {
    var state: GraphState = .dfs
    var matrix: [[CustomCell]] = []
    var target: [Int] = []
    var queue: [[Int]] = []
    var seen: Set<String> = []
    var searchSpeed: Timer?
    
    func generateMatrix(_ arr: [CustomCell]) {
        var matrix: [[CustomCell]] = []
        var row: [CustomCell] = []
        
        for cell in arr {
            if cell.backgroundColor == .green {
                queue.append([matrix.count, row.count])
                seen.insert("\(matrix.count)-\(row.count)")
            } else if cell.backgroundColor == .red {
                target = [matrix.count, row.count]
            }
            
            row.append(cell)
            
            if row.count == 17 {
                matrix.append(row)
                row = []
            }
        }
        
        self.matrix = matrix
    }
    
    func startSearch() {
        if state == .greedy {
            searchSpeed = Timer.scheduledTimer(timeInterval: 0.03, target: self, selector: #selector(greedy), userInfo: nil, repeats: true)
        } else if state == .bfs {
            searchSpeed = Timer.scheduledTimer(timeInterval: 0.005, target: self, selector: #selector(bfs), userInfo: nil, repeats: true)
        } else {
            searchSpeed = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(dfs), userInfo: nil, repeats: true)
        }
        
    }
    
    @objc func bfs() {
        let dirs = [[0, 1], [0, -1], [1, 0], [-1, 0]]
        let curr = queue.removeFirst()
        let currRow = curr[0]
        let currCol = curr[1]
        
        if matrix[currRow][currCol].backgroundColor == .red {
            matrix[currRow][currCol].backgroundColor = .blue
            queue = []
            seen = []
            searchSpeed?.invalidate()
            return
        }
        
        matrix[currRow][currCol].tag = 1
        matrix[currRow][currCol].backgroundColor = .green
        
        
        for dir in dirs {
            let newRow = currRow + dir[0]
            let newCol = currCol + dir[1]
            
            if newRow < 0 || newRow >= matrix.count ||
                newCol < 0 || newCol >= matrix[0].count ||
                matrix[newRow][newCol].tag == 1 || seen.contains("\(newRow)-\(newCol)") ||
                matrix[newRow][newCol].backgroundColor == .gray {
                continue
            }
            
            seen.insert("\(newRow)-\(newCol)")
            queue.append([newRow, newCol])
        }
    }
    
    @objc func dfs() {
        let dirs = [[0, 1], [0, -1], [1, 0], [-1, 0]]
        let curr = queue.removeLast()
        let currRow = curr[0]
        let currCol = curr[1]
        
        if matrix[currRow][currCol].backgroundColor == .red {
            matrix[currRow][currCol].backgroundColor = .blue
            queue = []
            seen = []
            searchSpeed?.invalidate()
            return
        }
        
        matrix[currRow][currCol].tag = 1
        matrix[currRow][currCol].backgroundColor = .green
        
        
        for dir in dirs {
            let newRow = currRow + dir[0]
            let newCol = currCol + dir[1]
            
            if newRow < 0 || newRow >= matrix.count ||
                newCol < 0 || newCol >= matrix[0].count ||
                matrix[newRow][newCol].tag == 1 || seen.contains("\(newRow)-\(newCol)") ||
                matrix[newRow][newCol].backgroundColor == .gray {
                continue
            }
            
            seen.insert("\(newRow)-\(newCol)")
            queue.append([newRow, newCol])
        }
    }
    
    @objc func greedy() {
        let dirs = [[0, 1], [0, -1], [1, 0], [-1, 0]]
        let targetRow = target[0]
        let targetCol = target[1]
        var curr: [Int] = []
        
        for (i, dir) in queue.enumerated() {
            if curr.isEmpty {
                curr = dir
                curr.append(i)
            } else {
                let prevRowWeight = max(curr[0], targetRow) - min(curr[0], targetRow)
                let prevColWeight = max(curr[1], targetCol) - min(curr[1], targetCol)
                let currRowWeight = max(dir[0], targetRow) - min(dir[0], targetRow)
                let currColWeight = max(dir[1], targetCol) - min(dir[1], targetCol)
                
                if currRowWeight + currColWeight < prevRowWeight + prevColWeight {
                    print(currRowWeight + currColWeight, prevRowWeight + prevColWeight)
                    curr = dir
                    curr.append(i)
                }
            }
        }
        
        let currRow = curr[0]
        let currCol = curr[1]
        
        queue.remove(at: curr[2])
        
        if matrix[currRow][currCol].backgroundColor == .red {
            matrix[currRow][currCol].backgroundColor = .blue
            queue = []
            seen = []
            searchSpeed?.invalidate()
            return
        }
        
        matrix[currRow][currCol].tag = 1
        matrix[currRow][currCol].backgroundColor = .green
            
        for dir in dirs {
            let newRow = currRow + dir[0]
            let newCol = currCol + dir[1]

            if newRow < 0 || newRow >= matrix.count ||
                newCol < 0 || newCol >= matrix[0].count ||
                matrix[newRow][newCol].tag == 1 || seen.contains("\(newRow)-\(newCol)") ||
                matrix[newRow][newCol].backgroundColor == .gray {
                continue
            }
            
            seen.insert("\(newRow)-\(newCol)")
            queue.append([newRow, newCol])
        }
    }
}
