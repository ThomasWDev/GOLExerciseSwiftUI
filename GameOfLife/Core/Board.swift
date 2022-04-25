import Foundation
public class Board: ObservableObject {
    var alive: Set<Cell> = []
    var allCells: Array<Cell> = []
    
    var matricsSize: Int64 = 10
    
    public func makeBoard() {
       for x in 0..<matricsSize {
            for y in 0..<matricsSize {
                
               allCells.append(Cell(x: x, y: y))
                let randomInt = Int64.random(in: 2..<5)
                //make initially active if row && colum can divide  by random(2 to 5)
                if (x%randomInt) == 0  {
                    active(cell: Cell(x: x, y: y))
                }
            }
       }
        
    }
    
    public func active(cell: Cell) {
        alive.insert(cell)
    }
    
    public func neighborCounts() -> [Cell: Int] {
        var counts: [Cell: Int] = [:]
        for cell in alive {
            for neighbor in cell.neighbors() {
                let count = counts[neighbor] ?? 0
                counts[neighbor] = count + 1
            }
        }
        
        return counts
    }
    
    public func step() {
        var newAlive: Set<Cell> = []
        
        for (key: cell, value: count) in neighborCounts() {
            if count == 3 || alive.contains(cell) && count == 2 {
                newAlive.insert(cell)
            }
        }
        
        alive = newAlive
        
        if alive.isEmpty {
            //stop the game
            return
        } else {
            //notify to update ui
            objectWillChange.send()
        }
    }
    
}
