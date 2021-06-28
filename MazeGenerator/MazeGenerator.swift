//
//  MazeGenerator.swift
//  MazeGenerator
//
//  Created by Ben Gottlieb on 6/28/21.
//

import Suite

protocol MazeGenerator: ObservableObject {
	var maze: Maze { get set }
	var isGenerating: Bool { get }
	var random: SeededRandomNumberGenerator { get set }
	var timer: Timer? { get set }
	var randomSeed: Int? { get set }
	var done: Bool { get set }

	func start(interval: TimeInterval)
	func prepare()
	func continueGeneration(asynchronously: Bool)

	init(maze: Maze, seed: Int?)
}

extension MazeGenerator {
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
}
