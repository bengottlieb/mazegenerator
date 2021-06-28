//
//  Maze.Position.swift
//  MazeGenerator
//
//  Created by Ben Gottlieb on 6/28/21.
//

import Foundation

extension Maze {
	func index(_ x: Int, _ y: Int) -> Int {
		x + y * width
	}
	
	func index(_ position: Position) -> Int {
		index(position.x, position.y)
	}

	func index(_ position: Position, _ direction: Direction) -> Int? {
		var pos = position
		
		switch direction {
		case .left: pos.x -= 1
		case .right: pos.x += 1
		case .up: pos.y -= 1
		case .down: pos.y += 1
		default: break
		}
		if isValid(pos) { return index(pos.x, pos.y) }
		return nil
	}
	
	func isValid(_ pos: Position) -> Bool {
		pos.x >= 0 && pos.x < width && pos.y >= 0 && pos.y < height
	}

	mutating func remove(wall: Wall, at position: Position) {
		cells[index(position)].remove(wall)
		if let index = index(position, wall), let inverse = wall.inverse {
			cells[index].remove(inverse)
		}
	}

	struct Position {
		var x: Int
		var y: Int
		init(_ x: Int, _ y: Int) {
			self.x = x
			self.y = y
		}
      
      func isConnected(to other: Position) -> Bool {
         if x == other.x { return abs(y - other.y) == 1 }
         if y == other.y { return abs(x - other.x) == 1 }
         return false
      }
	}
}
