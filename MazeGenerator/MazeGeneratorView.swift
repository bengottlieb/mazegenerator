//
//  MazeGeneratorView.swift
//  MazeGenerator
//
//  Created by Ben Gottlieb on 6/28/21.
//

import SwiftUI

struct MazeGeneratorView: View {
   @StateObject var generator: MazeGenerator_Prim
   
   var body: some View {
      MazeView(maze: generator.maze)
   }
}
