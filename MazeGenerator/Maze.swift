//
//  Maze.swift
//  MazeGenerator
//
//  Created by Ben Gottlieb on 6/27/21.
//

import Foundation



struct Maze {
	var cells: [Cell]
	var width: Int

	var height: Int { cells.count / width }
	var isEmpty: Bool { cells.isEmpty }
	
	subscript(x: Int, y: Int) -> Cell? {
		if x < 0 || x >= width || y < 0 || y >= height { return nil }
		return cells[y * width + x]
	}
	
	subscript(position: Position) -> Cell {
		cells[index(position)]
	}
	
	subscript(position: Position, direction: Direction) -> Cell? {
		if let index = index(position, direction) {
			return cells[index]
		}
		return nil
	}
	
	init(width: Int, height: Int) {
		self.width = width
		cells = Array(repeating: Cell(walls: .all), count: height * width)
      for y in 0..<height {
         for x in 0..<width {
            cells[y * width + x].position = Position(x, y)
         }
      }
	}
	
	mutating func clear() {
		for i in cells.indices {
			cells[i].visited = false
			cells[i].walls = .all
		}
	}
   
   func randomCell() -> Cell {
      cells.randomElement()!
   }
	
	static let empty = Maze(width: 0, height: 0)
}

extension Maze {
	typealias Wall = Direction
	struct Direction: OptionSet {
		let rawValue: Int

		static var left = Direction(rawValue: 1 << 0)
		static var right = Direction(rawValue: 1 << 1)
		static var up = Direction(rawValue: 1 << 3)
		static var down = Direction(rawValue: 1 << 4)
		
		static var all: Direction = [.left, .right, .up, .down]
		static var none: Direction = []
		
		var inverse: Direction? {
			switch self {
			case .left: return .right
			case .right: return .left
			case .up: return .down
			case .down: return .up
			default: return nil
			}
		}
	}
}
