//
//  Node.swift
//  Graph-Path-Finding
//
//  Created by Edward O'Neill on 3/8/21.
//

import Foundation

class Node {
    var weight = 500
    var val: Int
    var neighbors: [Node] = []
    var row = 0
    var col = 0
    
    init(_ val: Int, _ row: Int, _ col: Int) {
        self.val = val
        self.row = row
        self.col = col
    }
}
