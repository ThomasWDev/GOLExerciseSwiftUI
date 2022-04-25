//
//  ContentView.swift
//  GameOfLife
//
//  Created by ThomasWDev on 4/22/22.
//

import SwiftUI








struct ContentView: View {
    //Board object for calculations of all Game of life logic
    var board = Board()
    
    // refresh ui every step -> generation
    @State var refresh = false
    
    // game start state , by default false . it will change in start button action
    @State var gameStart = false
  
   
    //MARK: - UI
    var body: some View {
        
        VStack {
            
            // Title
            Text("Game of Life ")
                .foregroundColor(Color.black)
                .font(.headline)
            Spacer()
            
            //GOLF canvas
            if refresh || !refresh {
                
                Canvas.init { context, size in
                    //make resize of cell based on Board size
                    let perSize: CGFloat = CGFloat(size.width / CGFloat(board.matricsSize))
                    
                    for cell in board.allCells {
                        //calculate position 
                        let xPos: CGFloat = CGFloat(CGFloat(cell.x) * perSize)
                        let yPos: CGFloat = CGFloat(CGFloat(cell.y) * perSize)
                        
                        //make rect and fill color if active then green else gray
                        let cellRect = CGRect(
                            x: xPos,
                            y: yPos,
                            width: perSize,
                            height: perSize)
                        //make fill
                        context.fill(
                            Path(cellRect),
                            with: .color(board.alive.contains(cell) ? .blue : .gray))
                    }
                }
            }
            
            //input for board size & start button
            VStack {
                HStack {
                    Text("Enter Board Size")
                    Spacer()
                }
                TextField.init("minimum 10", text: Binding<String>.init(get: {
                    return "\(board.matricsSize)"
                }, set: { str in
                    board.matricsSize = (Int64(str) ?? 10) < 10 ? 10 : (Int64(str) ?? 10)
                }))
                .disabled(gameStart ? true : false)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                
                // start and stop game Button
                Button {
                    //Button action
                    gameStart.toggle()
                    
                    if gameStart == false {
                        board.alive = [] //make empty when stop game by button tap
                        refresh.toggle()
                    } else {
                        board.makeBoard()
                        board.step()
                    }//:else
                } label: {
                    HStack {
                        Spacer()
                        Text(gameStart ? "Stop" : "Start")
                            .foregroundColor(Color.white)
                            .font(.headline)
                        Spacer()
                    }.padding()
                        .background(gameStart ? Color.red : Color.green)
                }//:Button
                
            }//:Inner VStack
            .padding()
            
            
            Spacer()
        }//: VStack
        .onReceive(board.objectWillChange, perform: { _ in
            //refresh ui for current state
            refresh.toggle()
            //call next step again after 0.1 delay
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                board.step()
            }
            
        })//:onReceive
    }//:body
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
