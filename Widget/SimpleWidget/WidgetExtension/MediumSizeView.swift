//
//  MediumSizeView.swift
//  SimpleWidget
//
//  Created by Shawn Frank on 24/7/2023.
//

import WidgetKit
import SwiftUI

struct MediumSizeView: View {
    var entry: SimpleEntry
    
    @State var imageURL: URL?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(spacing: 0) {
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.white)
                            .frame(height: geometry.size.height / 2) // Half of the parent's height
                        
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.blue)
                            .shadow(radius: 5)
                            .frame(width: geometry.size.height / 2.5, height: geometry.size.height / 2.5) // Square size
                            .padding()
                            .padding(.trailing, 20) // Left-align the square with some padding
                    }
                    
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: geometry.size.height / 2) // Half of the parent's height
                        
                        LazyVGrid(columns: createGridColumns(geometry: geometry), spacing: 0) {
                            ForEach(0..<8) { index in
                                Rectangle()
                                    .fill(Color.gray)
                                    .frame(width: geometry.size.width / 4, height: 50)
                            }
                        }
                    }
                }
            }
            
            Link(destination: URL(string: "testwidget://link1")!) {
                Text("Hello")
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .background(.orange)
            }
        }
        
    }
    
    private func createGridColumns(geometry: GeometryProxy) -> [GridItem] {
        let columnWidth = geometry.size.width / 4
        return Array(repeating: GridItem(.fixed(columnWidth), spacing: 10), count: 4)
    }
}
