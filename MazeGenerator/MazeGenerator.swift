//
//  MazeGenerator.swift
//  MazeGenerator
//
//  Created by Ben Gottlieb on 6/28/21.
//

import Suite

class MazeGenerator: ObservableObject {
	var random = SeededRandomNumberGenerator(seed: Int(Date().timeIntervalSinceReferenceDate))
	var maze: Maze
	var done = false { didSet { objectWillChange.send() }}
	weak var timer: Timer?
	var randomSeed: Int?
	
	required init(maze: Maze, seed: Int? = nil) {
		self.randomSeed = seed
		self.maze = maze
	}
	func prepare() { }
	
	func generateSingleStep() -> MazeGenerationStepResult { return .completed }
}


extension MazeGenerator {
	enum MazeGenerationStepResult { case completed, noChange, changed }
	var isGenerating: Bool { timer != nil && !done }

	func start(interval: TimeInterval = 0.1) {
		timer?.invalidate()
		if let seed = randomSeed { random = SeededRandomNumberGenerator(seed: seed) }

		if maze.isEmpty { return }
		maze.clear()
		done = false
		prepare()

		if interval != 0 {
			timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true, block: { _ in self.continueGeneration(asynchronously: true) })
		} else {
			self.continueGeneration(asynchronously: false)
		}
	}
	
	func cancel() {
		timer?.invalidate()
		done = true
	}
	
	func continueGeneration(asynchronously: Bool) {
		while true {
			var found = false
			let stepResult = done ? .completed : generateSingleStep()
			guard stepResult != .completed else {
				timer?.invalidate()
				done = true
				break
			}
			
			if stepResult == .changed { found = true }
			
			if asynchronously, found {
				return
			}
		}
	}

}

extension MazeGenerator {
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
