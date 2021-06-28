//
//  ContentView.swift
//  MazeGenerator
//
//  Created by Ben Gottlieb on 6/27/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
		MazeView(maze: Maze(width: 10, height: 10))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
