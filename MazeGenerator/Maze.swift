//
//  Maze.swift
//  MazeGenerator
//
//  Created by Ben Gottlieb on 6/27/21.
//

import Foundation



struct Maze {
	var cells: [[Cell]]
	
	var width: Int { cells[0].count }
	var height: Int { cells.count }
	
	subscript(x: Int, y: Int) -> Cell? {
		if x < 0 || x >= width || y < 0 || y >= height { return nil }
		return cells[y][x]
	}
	
	init(width: Int, height: Int) {
		cells = Array(repeating: Array(repeating: Cell(walls: .all), count: width), count: height)
      for y in 0..<height {
         for x in 0..<width {
            cells[y][x].position = Position(x, y)
         }
      }
	}
   
   func randomCell() -> Cell {
      cells.randomElement()!.randomElement()!
   }
}

extension Maze {
	struct Cell {
		var walls: Wall = []
		var visited = false
      var position = Position(0, 0)
      
      mutating func remove(_ wall: Wall) {
         
      }
      
      var allWalls: [Wall] {
         [Wall.left, Wall.right, Wall.top, Wall.bottom].compactMap { wall in
            walls.contains(wall) ? wall : nil
         }
      }
      
      mutating func remove(wall: Wall, atX x: Int, y: Int) {
         cells[y][x].remove(wall)
         
         switch wall {
         case .top: if y > 0 { cells[y - 1][x].remove(.bottom) }
         case .bottom: if y < (height - 1) { cells[y + 1][x].remove(.top) }
         case .left: if x > 0 { cells[y][x - 1].remove(.right) }
         case .right: if x < (width - 1) { cells[y][x + 1].remove(.left) }
         default: break
         }
      }
	}
	
   struct Position {
      let x: Int
      let y: Int
      init(_ x: Int, _ y: Int) {
         self.x = x
         self.y = y
      }
   }
   
	struct Wall: OptionSet {
		let rawValue: Int

		static var left = Wall(rawValue: 1 << 0)
		static var right = Wall(rawValue: 1 << 1)
		static var top = Wall(rawValue: 1 << 3)
		static var bottom = Wall(rawValue: 1 << 4)
		
		static var all: Wall = [.left, .right, .top, .bottom]
	}
}
