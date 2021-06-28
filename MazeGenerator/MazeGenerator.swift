//
//  MazeGenerator.swift
//  MazeGenerator
//
//  Created by Ben Gottlieb on 6/27/21.
//

import SwiftUI
import Foundation

class MazeGenerator {
   var maze: Binding<Maze>
   var walls: [CellWall] = []
   
   struct CellWall {
      let wall: Maze.Wall
      let x: Int
      let y: Int
   }
   
   init(maze: Binding<Maze>) {
      self.maze = maze
   }
   
   func start(interval: TimeInterval = 0.1) {
      let seed = maze.wrappedValue.randomCell()
      
      walls = seed.allWalls.map { CellWall(wall: $0, x: seed.position.x, y: seed.position.y) }
      
   }
}

