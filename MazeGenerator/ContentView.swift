//
//  ContentView.swift
//  MazeGenerator
//
//  Created by Ben Gottlieb on 6/27/21.
//

import SwiftUI

struct ContentView: View {
   @StateObject var generator = MazeGenerator(maze: Maze(width: 7, height: 7), seed: 2)
   
   var body: some View {
      VStack() {
         MazeGeneratorView(generator: generator)
            .padding()
         
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
   }
   
   func cancel() {
      generator.cancel()
   }
   
   func generate(fast: Bool) {
      generator.start(interval: fast ? 0 : 0.000001)
   }
}

struct ContentView_Previews: PreviewProvider {
   static var previews: some View {
      ContentView()
   }
}
