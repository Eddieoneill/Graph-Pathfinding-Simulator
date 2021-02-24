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
}

class GraphSearchOptions {
    var state: GraphState = .dfs
    var matrix: [[CustomCell]] = []
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
        print(queue)
        searchSpeed = Timer.scheduledTimer(timeInterval: 0.005, target: self, selector: #selector(dfs), userInfo: nil, repeats: true)
    }
    
    @objc func dfs() {
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
}
