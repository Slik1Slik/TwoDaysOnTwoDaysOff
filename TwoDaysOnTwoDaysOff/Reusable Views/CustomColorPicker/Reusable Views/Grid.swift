//
//  GridPath.swift
//  CustomColorPicker
//
//  Created by Slik on 19.04.2022.
//

import SwiftUI

struct Grid: View {
    
    let rowsCount: Int
    let columnsCount: Int
    let gridColor: Color
    
    let hasBorder: Bool
    
    var body: some View {
        GeometryReader { geometry in
            
            let width = geometry.size.width
            let height = geometry.size.height
            
            let xSpacing = width / CGFloat(columnsCount)
            let ySpacing = height / CGFloat(rowsCount)
            
            let columnsLowerBound = hasBorder ? 0 : 1
            let columnsUpperBound = hasBorder ? columnsCount : columnsCount - 1
            
            let rowsLowerBound = hasBorder ? 0 : 1
            let rowsUpperBound = hasBorder ? rowsCount : rowsCount - 1
            
            Path { path in
                
                for index in columnsLowerBound...columnsUpperBound {
                    let vOffset: CGFloat = CGFloat(index) * xSpacing
                    path.move(to: CGPoint(x: vOffset, y: 0))
                    path.addLine(to: CGPoint(x: vOffset, y: height))
                }
                for index in rowsLowerBound...rowsUpperBound {
                    let hOffset: CGFloat = CGFloat(index) * ySpacing
                    path.move(to: CGPoint(x: 0, y: hOffset))
                    path.addLine(to: CGPoint(x: width, y: hOffset))
                }
            }
            .stroke(gridColor)
        }
    }
    
    init(rowsCount: Int = 5,
         columnsCount: Int = 5,
         gridColor: Color = .secondary.opacity(0.2),
         hasBorder: Bool = true)
    {
        self.rowsCount = rowsCount
        self.columnsCount = columnsCount
        self.gridColor = gridColor
        self.hasBorder = hasBorder
    }
}

struct Grid_Previews: PreviewProvider {
    static var previews: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(.clear)
            .background(
                Grid(hasBorder: false)
            )
            .frame(width: 150, height: 150)
    }
}
