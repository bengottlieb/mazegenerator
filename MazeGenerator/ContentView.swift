//
//  ContentView.swift
//  MazeGenerator
//
//  Created by Ben Gottlieb on 6/27/21.
//

import SwiftUI

struct ContentView: View {
	@State var maze = Maze(width: 10, height: 10)
	@StateObject var generator = MazeGenerator()
	@State var done = true
	
    var body: some View {
		VStack() {
			MazeView(maze: $maze, generator: generator, done: $done)
				.padding()
			
			Button(action: generate) {
				Text("Build")
					.padding()
			}
		}
    }

	
	func generate() {
		maze.clear()
		generator.start(maze: $maze, done: $done, interval: 0.005)
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
