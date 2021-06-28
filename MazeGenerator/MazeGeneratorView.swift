//
//  MazeGeneratorView.swift
//  MazeGenerator
//
//  Created by Ben Gottlieb on 6/28/21.
//

import SwiftUI

struct MazeGeneratorView<Generator: MazeGenerator>: View {
   @ObservedObject var generator: Generator
	@State var randomized = true
   
   var body: some View {
		VStack() {
			MazeView(maze: generator.maze)
				.padding()
			
			Toggle("Randomized", isOn: $randomized.onChange { randomized in
				generator.randomSeed = randomized ? nil : 1
			})
		}
		.onAppear() {
			randomized = generator.randomSeed == nil
		}
   }
}
