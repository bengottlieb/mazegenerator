//
//  MazeGeneratorContainerView.swift
//  MazeGenerator
//
//  Created by Ben Gottlieb on 6/28/21.
//

import SwiftUI

struct MazeGeneratorContainerView: View {
	enum MazeKind: String, CaseIterable { case prim, growingTreeFirst, growingTreeLast, growingTreeRandom
		var title: String {
			switch self {
			case .prim: return "Prim"
			case .growingTreeFirst: return "Tree First"
			case .growingTreeLast: return "Tree Last"
			case .growingTreeRandom: return "Tree Random"
			}
		}
	}
	
	@State var generator: MazeGenerator
	@State var randomized = true
	@State var kind = MazeKind.prim
	
	var segments: some View {
		Picker("", selection: $kind.onChange { kind in
			generator.cancel()
			
			switch kind {
			case .prim: generator = PrimMazeGenerator(maze: generator.maze)
			case .growingTreeFirst: generator = GrowingTreeMazeGenerator(maze: generator.maze, style: .first)
			case .growingTreeLast: generator = GrowingTreeMazeGenerator(maze: generator.maze, style: .last)
			case .growingTreeRandom: generator = GrowingTreeMazeGenerator(maze: generator.maze, style: .random)
			}
			generate(fast: true)
		}) {
			ForEach(MazeKind.allCases, id: \.self) { kind in
				Text(kind.title).tag(kind)
			}
		}
		.pickerStyle(SegmentedPickerStyle())
	}
	
	var body: some View {
		VStack() {
			segments
			
			MazeGeneratorView(generator: generator)
			Toggle("Randomized", isOn: $randomized.onChange { randomized in
				generator.randomSeed = randomized ? nil : 1
			})

			
			HStack() {
				if generator.isGenerating {
					Button(action: { cancel() }) {
						Text("Cancel").padding()
					}
				} else {
					Button(action: { generate(fast: true) }) {
						Text("Build Fast").padding()
					}
					Button(action: { generate(fast: false) }) {
						Text("Build Slow").padding()
					}
				}
			}
			.buttonStyle(DefaultButtonStyle())
		}
		.onAppear() {
			randomized = generator.randomSeed == nil
		}
	}

	func cancel() {
		generator.cancel()
	}
	
	func generate(fast: Bool) {
		generator.start(interval: fast ? 0 : 0.000001)
	}
}

struct MazeGeneratorContainerView_Previews: PreviewProvider {
	static var previews: some View {
		MazeGeneratorContainerView(generator: GrowingTreeMazeGenerator(maze: Maze(width: 10, height: 10)))
	}
}
