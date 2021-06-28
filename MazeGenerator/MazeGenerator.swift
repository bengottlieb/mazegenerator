//
//  MazeGenerator.swift
//  MazeGenerator
//
//  Created by Ben Gottlieb on 6/27/21.
//

import Suite

class MazeGenerator: ObservableObject {
	var maze: Binding<Maze> = .constant(.empty)
	var done: Binding<Bool> = .constant(true)
   var walls: [CellWall] = []
	weak var timer: Timer?
   
   struct CellWall {
      let wall: Maze.Wall
		let position: Maze.Position
   }
   
	init() {
	}
	
	init(maze: Binding<Maze>, done: Binding<Bool>) {
      self.maze = maze
		self.done = done
   }
   
	func start(maze newMaze: Binding<Maze>? = nil, done newDone: Binding<Bool>? = nil, interval: TimeInterval = 0.1) {
		if let maze = newMaze { self.maze = maze }
		if let done = newDone { self.done = done }
		timer?.invalidate()

		if maze.wrappedValue.isEmpty { return }
		done.wrappedValue = false
      let seed = maze.wrappedValue.randomCell()
      
      walls = seed.allGeneratorWalls
		maze.wrappedValue[visited: seed.position] = true
		if interval != 0 {
			timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true, block: { _ in self.continueGeneration(interval: interval) })
		} else {
			self.continueGeneration(interval: interval)
		}
   }
	
	func continueGeneration(interval: TimeInterval) {
		while !done.wrappedValue {
			guard walls.isNotEmpty else {
				timer?.invalidate()
				done.wrappedValue = true
				print("Done")
				break
			}
			
			let index = Int(Int.random(to: UInt32(walls.count)))
			let wall = walls[index]
			walls.remove(at: index)
			for cell in cells(relativeTo: wall) {
				if !maze.wrappedValue[visited: cell.position] {
					maze.wrappedValue[visited: cell.position] = true
					maze.wrappedValue.remove(wall: cell.wall, at: cell.position)
					walls += maze.wrappedValue[cell.position].allGeneratorWalls
				}
			}
			
			if interval > 0 {
				self.objectWillChange.send()
				break
			}
		}
	}
	
	func cells(relativeTo wall: CellWall) -> [CellWall] {
		var result = [wall]
		if let inverse = wall.wall.inverse, let otherSide = maze.wrappedValue[wall.position, wall.wall] {
			result.append(CellWall(wall: inverse, position: otherSide.position))
		}
		return result
	}
}

extension Maze.Cell {
	var allGeneratorWalls: [MazeGenerator.CellWall] {
		allWalls.map { MazeGenerator.CellWall(wall: $0, position: position) }
	}
}
