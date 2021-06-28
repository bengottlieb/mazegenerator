//
//  Maze.Cell.swift
//  MazeGenerator
//
//  Created by Ben Gottlieb on 6/28/21.
//

import Foundation

extension Maze {
   subscript(visited position: Position) -> Cell.State {
		get { self[position].state }
		set { self.cells[index(position)].state = newValue }
	}

	struct Cell {
      struct State: OptionSet {
         let rawValue: Int
         
         static let visited = State(rawValue: 1 << 0)
      }

      var walls: Wall = []
      var state: State = []
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
