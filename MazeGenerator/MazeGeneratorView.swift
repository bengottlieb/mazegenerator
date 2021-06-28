//
//  MazeGeneratorView.swift
//  MazeGenerator
//
//  Created by Ben Gottlieb on 6/28/21.
//

import SwiftUI

struct MazeGeneratorView<Generator: MazeGenerator>: View {
   @StateObject var generator: Generator
   
   var body: some View {
      MazeView(maze: generator.maze)
   }
}
