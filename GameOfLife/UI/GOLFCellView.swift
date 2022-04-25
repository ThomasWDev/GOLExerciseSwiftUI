//
//  GOLFCellView.swift
//  GameOfLife
//
//  Created by ThomasWDev on 4/22/22.
//

import SwiftUI


struct GOLFCellView: View {
    var isActive = false
    
    //MARK: - UI
    var body: some View {
        VStack {
            Rectangle()
                .fill(isActive ? Color.green : Color.gray)
                .overlay(
                    Rectangle()
                        .stroke()
                        .foregroundColor(Color.gray)
                )
        }
    }
}
