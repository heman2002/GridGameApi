//
//  GridGameApi.swift
//  GridGameApi
//
//  Created by himanshu singhal on 29/07/17.
//  Copyright © 2017 himanshu singhal. All rights reserved.
//

import Foundation
import SpriteKit
import RxSwift

public enum Direction {
    case left,up,right,down
}

var direction:Direction = Direction.down

class Grid:SKSpriteNode {
    var rows:Int!
    var cols:Int!
    var blockSize:CGFloat!
    
    convenience init?(blockSize:CGFloat,rows:Int,cols:Int) {
        guard let texture = Grid.gridTexture(blockSize: blockSize,rows: rows, cols:cols) else {
            return nil
        }
        self.init(texture: texture, color:SKColor.clear, size: texture.size())
        self.blockSize = blockSize
        self.rows = rows
        self.cols = cols
        self.isUserInteractionEnabled = true
    }
    
    class func gridTexture(blockSize:CGFloat,rows:Int,cols:Int) -> SKTexture? {
        // Add 1 to the height and width to ensure the borders are within the sprite
        let size = CGSize(width: CGFloat(cols)*blockSize+1.0, height: CGFloat(rows)*blockSize+1.0)
        UIGraphicsBeginImageContext(size)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        let bezierPath = UIBezierPath()
        let offset:CGFloat = 0.5
        
        // Draw vertical lines
        var x = CGFloat(0)*blockSize + offset
        bezierPath.move(to: CGPoint(x: x, y: 0))
        bezierPath.addLine(to: CGPoint(x: x, y: size.height))
        
        // Draw horizontal lines
        var y = CGFloat(0)*blockSize + offset
        bezierPath.move(to: CGPoint(x: 0, y: y))
        bezierPath.addLine(to: CGPoint(x: size.width, y: y))
        
        x = CGFloat(cols)*blockSize + offset
        bezierPath.move(to: CGPoint(x: x, y: 0))
        bezierPath.addLine(to: CGPoint(x: x, y: size.height))
        
        // Draw horizontal lines
        y = CGFloat(rows)*blockSize + offset
        bezierPath.move(to: CGPoint(x: 0, y: y))
        bezierPath.addLine(to: CGPoint(x: size.width, y: y))
        
        
        SKColor.white.setStroke()
        bezierPath.lineWidth = 1.0
        bezierPath.stroke()
        context.addPath(bezierPath.cgPath)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return SKTexture(image: image!)
    }
    
    func gridPosition(row:Int, col:Int) -> CGPoint {
        let offset = blockSize / 2.0 + 0.5
        let x = CGFloat(col) * blockSize - (blockSize * CGFloat(cols)) / 2.0 + offset
        let y = CGFloat(rows - row - 1) * blockSize - (blockSize * CGFloat(rows)) / 2.0 + offset
        return CGPoint(x:x, y:y)
    }
    
    //    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    //        for touch in touches {
    //            let position = touch.location(in:self)
    //            let node = atPoint(position)
    //            // print(self.children)
    //            if node != self {
    //                print("do nothing")
    //            }
    //            else {
    //                let diffX = position.x - (self.childNode(withName: "snake")?.position.x)!
    //                let diffY = position.y - (self.childNode(withName: "snake")?.position.y)!
    //                if (diffX > 0 ) {
    //                    if(diffX >= abs(diffY)) {
    //                        print("move right")
    //                        direction = Direction.right
    //                    }
    //                    else if ( diffY > 0) {
    //                        print("move up")
    //                        direction = Direction.up
    //                    }
    //                    else {
    //                        print("move down")
    //                        direction = Direction.down
    //                    }
    //                }
    //                else {
    //                    if(abs(diffX) >= abs(diffY)) {
    //                        print("move left")
    //                        direction = Direction.left
    //                    }
    //                    else if ( diffY > 0) {
    //                        print("move up")
    //                        direction = Direction.up
    //                    }
    //                    else {
    //                        print("move down")
    //                        direction = Direction.down
    //                    }
    //                }
    //            }
    //        }
    //    }
}
var grid = Grid()

class Layer: SKNode {
    var color: SKColor
    init(color: SKColor) {
        self.color = color
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Layer {
    open func fill(x:Int,y:Int) {
        let object = SKSpriteNode()
        object.position = (grid.gridPosition(row: x, col: y))
        object.color = self.color
        self.addChild(object)
    }
    open func clear(x:Int,y:Int) {
        for object in self.children {
            if (object.position == (grid.gridPosition(row: x, col: y))) {
                object.removeFromParent()
            }
        }
    }
    open func getActiveSquares() -> [SKSpriteNode] {
        return self.children as! [SKSpriteNode]
    }
}

func initGrid(squareSize: CGFloat) {
    grid = Grid(blockSize: squareSize, rows: 25, cols: 25)!
}

func addLayer(color: SKColor) -> SKNode {
    let layer = Layer(color: color)
    return layer
}

private func random() -> CGFloat {
    return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
}

private func random(min: CGFloat, max: CGFloat) -> CGFloat {
    return random() * (max - min) + min
}

func randomSquare() -> (Int,Int){
    let x = random().truncatingRemainder(dividingBy: 15)
    let y = random().truncatingRemainder(dividingBy: 15)
    return (Int(x),Int(y))
}
