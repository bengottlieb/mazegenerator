//
//  MazeGenerator.swift
//  MazeGenerator
//
//  Created by Ben Gottlieb on 6/27/21.
//

import Suite

class PrimMazeGenerator: MazeGenerator {
   var random = SeededRandomNumberGenerator(seed: Int(Date().timeIntervalSinceReferenceDate))
   var maze: Maze
	var done = false { didSet { objectWillChange.send() }}
   var walls: [CellWall] = []
	weak var timer: Timer?
   var isGenerating: Bool { timer != nil && !done }
   var randomSeed: Int?
   var visited = Visited(width: 1, height: 1)
   
   struct CellWall {
      let wall: Maze.Wall
		let position: Maze.Position
   }
	
   required init(maze: Maze, seed: Int? = nil) {
      self.randomSeed = seed
      self.maze = maze
   }
   
	func prepare() {
		visited = Visited(width: maze.width, height: maze.height)
		
		let seed = maze.randomCell(using: &random)
		walls = seed.allGeneratorWalls(using: &random)
		visited[seed.position] = true
	}
   
	func generateSingleStep() -> MazeGenerationStepResult {
		guard let wall = nextWall else { return .completed }
		for cell in cells(relativeTo: wall) {
			if !visited[cell.position] {
				visited[cell.position] = true
				maze.remove(wall: cell.wall, at: cell.position)
				walls += maze[cell.position].allGeneratorWalls(using: &random)
				self.objectWillChange.send()
				return .changed
			}
		}
		return .noChange
	}

	var nextWall: CellWall? {
      self.walls.shuffle(using: &random)
      
		guard let found = walls.first else { return nil }
      walls.remove(at: 0)
      return found
   }
	
	func cells(relativeTo wall: CellWall) -> [CellWall] {
		var result = [wall]
		if let inverse = wall.wall.inverse, let otherSide = maze[wall.position, wall.wall] {
			result.append(CellWall(wall: inverse, position: otherSide.position))
		}
		return result
	}
}

extension Maze.Cell {
   func allGeneratorWalls(using random: inout SeededRandomNumberGenerator) -> [PrimMazeGenerator.CellWall] {
      allWalls.shuffled(using: &random).map { PrimMazeGenerator.CellWall(wall: $0, position: position) }
	}
}

extension PrimMazeGenerator {
   struct Visited {
      var list: [Bool]
      let width: Int
      init(width: Int, height: Int) {
         self.width = width
         list = Array(repeating: false, count: width * height)
      }
      subscript(position: Maze.Position) -> Bool {
         get { list[position.x + position.y * width] }
         set { list[position.x + position.y * width] = newValue }
      }
   }
}
