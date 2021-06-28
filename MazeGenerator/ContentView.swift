//
//  ContentView.swift
//  MazeGenerator
//
//  Created by Ben Gottlieb on 6/27/21.
//

import SwiftUI

struct ContentView: View {
   
   var body: some View {
      VStack() {
			MazeGeneratorContainerView(generator: GrowingTreeMazeGenerator(maze: Maze(width: 17, height: 17), seed: 2))
            .padding()
      }
   }
}

struct ContentView_Previews: PreviewProvider {
   static var previews: some View {
      ContentView()
   }
}
