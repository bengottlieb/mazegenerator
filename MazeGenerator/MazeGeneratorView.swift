//
//  MazeGeneratorView.swift
//  MazeGenerator
//
//  Created by Ben Gottlieb on 6/28/21.
//

import SwiftUI

struct MazeGeneratorView: View {
   @StateObject var generator: PrimMazeGenerator
   
   var body: some View {
      MazeView(maze: generator.maze)
   }
}
