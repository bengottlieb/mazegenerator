//
//  Maze.Cell.swift
//  MazeGenerator
//
//  Created by Ben Gottlieb on 6/28/21.
//

import Foundation

extension Maze {
	subscript(visited position: Position) -> Bool {
		get { self[position].visited }
		set { self.cells[index(position)].visited = newValue }
	}

	struct Cell {
		var walls: Wall = []
		var visited = false
		var position = Position(0, 0)
      var edgeCell: Bool = false
		
		mutating func remove(_ wall: Wall) {
         walls = walls.subtracting(wall)
		}
		
		var allWalls: [Wall] {
			[Wall.left, Wall.right, Wall.up, Wall.down].compactMap { wall in
				walls.contains(wall) ? wall : nil
			}
		}
	}
	
}
