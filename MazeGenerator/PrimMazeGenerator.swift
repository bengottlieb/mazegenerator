//
//  MazeGenerator.swift
//  MazeGenerator
//
//  Created by Ben Gottlieb on 6/27/21.
//

import Suite

class PrimMazeGenerator: MazeGenerator {
   var visited = Visited(width: 1, height: 1)
	var walls: [CellWall] = []

   struct CellWall {
      let wall: Maze.Wall
		let position: Maze.Position
   }
   
	override func prepare() {
		visited = Visited(width: maze.width, height: maze.height)
		
		let seed = maze.randomCell(using: &random)
		walls = seed.allGeneratorWalls(using: &random)
		visited[seed.position] = true
	}
   
	override func generateSingleStep() -> MazeGenerationStepResult {
		guard let wall = nextWall else { return .completed }
		for cell in cells(relativeTo: wall) {
			if !visited[cell.position] {
				visited[cell.position] = true
				maze.remove(wall: cell.wall, at: cell.position)
				walls += maze[cell.position].allGeneratorWalls(using: &random)
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
