//
//  GrowingTreeMazeGenerator.swift
//  MazeGenerator
//
//  Created by Ben Gottlieb on 6/28/21.
//

import Suite

class GrowingTreeMazeGenerator: MazeGenerator {
	var visited = Visited(width: 1, height: 1)
	var active: [Maze.Position] = []
	var style: Style = .last
	
	convenience init(maze: Maze, seed: Int? = nil, style: Style) {
		self.init(maze: maze, seed: seed)
		self.style = style
	}

	
	enum Style { case random, first, last }

	override func prepare() {
		visited = Visited(width: maze.width, height: maze.height)
		
		let seed = maze.randomCell(using: &random)
		active.append(seed.position)
		
		visited[seed.position] = true
	}
	
	func checkPosition() -> Maze.Position? {
		guard active.isNotEmpty else { return nil }
		
		switch style {
		case .first: return active[0]
		case .last: return active[active.count - 1]
		case .random: return active.randomElement(using: &random)
		}
	}
	
	override func generateSingleStep() -> MazeGenerator.MazeGenerationStepResult {
		guard let check = checkPosition() else { return .completed }
		let neighbors = maze.allNeigbors(of: check).shuffled(using: &random)
		
		for neighbor in neighbors {
			if !visited[neighbor] {
				visited[neighbor] = true
				active.append(neighbor)
				
				if let direction = check.direction(to: neighbor) {
					maze.remove(wall: direction, at: check)
				}
				
				return .changed
			}
		}
		
		active.remove(check)
		return .noChange
	}
}
