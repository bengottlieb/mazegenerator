//
//  MazeView.swift
//  MazeGenerator
//
//  Created by Ben Gottlieb on 6/27/21.
//

import SwiftUI

struct MazeView: View {
	@State var maze: Maze
	var body: some View {
		VStack(spacing: 0) {
			ForEach(0..<maze.height, id: \.self) { y in
				HStack(spacing: 0) {
					ForEach(0..<maze.width, id: \.self) { x in
						if let cell = maze[x, y] {
							Cell(cell: cell)
						}
					}
				}
			}
		}
		.aspectRatio(1.0, contentMode: .fit)
	}
}

extension MazeView {
	struct Cell: View {
		let cell: Maze.Cell
		var fill = Color.white
		var wall = Color.black
		var wallThickness: CGFloat = 2
		
		var body: some View {
			ZStack() {
				Rectangle()
					.fill(fill)
				
				HStack() {
					if cell.walls.contains(.left) {
						Rectangle()
							.fill(wall)
							.frame(width: wallThickness)
							.offset(x: -wallThickness / 2)
					}
					Spacer()
					if cell.walls.contains(.right) {
						Rectangle()
							.fill(wall)
							.frame(width: wallThickness)
							.offset(x: wallThickness / 2)
					}
				}
				
				VStack() {
					if cell.walls.contains(.top) {
						Rectangle()
							.fill(wall)
							.frame(height: wallThickness)
							.offset(y: -wallThickness / 2)
					}
					Spacer()
					if cell.walls.contains(.bottom) {
						Rectangle()
							.fill(wall)
							.frame(height: wallThickness)
							.offset(y: wallThickness / 2)
					}
				}

			}
		}
	}
}

struct MazeView_Previews: PreviewProvider {
	static var previews: some View {
		MazeView(maze: Maze(width: 10, height: 10))
			.padding()
	}
}
