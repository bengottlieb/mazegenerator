//
//  MazeGenerator.swift
//  MazeGenerator
//
//  Created by Ben Gottlieb on 6/27/21.
//

import Suite

class MazeGenerator: ObservableObject {
   var random = SeededRandomNumberGenerator(seed: Int(Date().timeIntervalSinceReferenceDate))
   var maze: Maze
	@Published var done = false
   var walls: [CellWall] = []
	weak var timer: Timer?
   var isGenerating: Bool { timer != nil && !done }
   var randomSeed: Int?
   
   struct CellWall {
      let wall: Maze.Wall
		let position: Maze.Position
   }
	
   init(maze: Maze, seed: Int? = nil) {
      self.randomSeed = seed
      self.maze = maze
   }
   
   func cancel() {
      timer?.invalidate()
      done = true
   }
   
	func start(interval: TimeInterval = 0.1) {
		timer?.invalidate()
      if let seed = randomSeed {
         random = SeededRandomNumberGenerator(seed: seed)
      }

		if maze.isEmpty { return }
      maze.clear()
		done = false
      let seed = maze.randomCell(using: &random)
      
      walls = seed.allGeneratorWalls(using: &random)
      maze[visited: seed.position] = true
		if interval != 0 {
         timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true, block: { _ in self.continueGeneration(asynchronously: true) })
		} else {
			self.continueGeneration(asynchronously: false)
		}
   }
	
   func continueGeneration(asynchronously: Bool) {
		while true {
         var found = false
			guard !done, walls.isNotEmpty else {
				timer?.invalidate()
				done = true
				print("Done")
				break
			}
			
         let index = Int.random(in: 0..<walls.count, using: &random)
			let wall = walls[index]
			walls.remove(at: index)
			for cell in cells(relativeTo: wall) {
				if !maze[visited: cell.position] {
               maze[visited: cell.position] = true
               maze.remove(wall: cell.wall, at: cell.position)
					walls += maze[cell.position].allGeneratorWalls(using: &random)
               found = true
				}
			}
			
			if asynchronously, found {
				self.objectWillChange.send()
				return
			}
		}
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
   func allGeneratorWalls(using random: inout SeededRandomNumberGenerator) -> [MazeGenerator.CellWall] {
      allWalls.shuffled(using: &random).map { MazeGenerator.CellWall(wall: $0, position: position) }
	}
}
