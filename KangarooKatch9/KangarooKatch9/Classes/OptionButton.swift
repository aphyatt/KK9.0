//
//  OptionButton.swift
//  KangarooKatch
//
//  Created by ADAM HYATT on 10/8/15.
//  Copyright © 2015 ADAM HYATT. All rights reserved.
//

import SpriteKit

class OptionButton: SKNode {

    var buttonLabel: GameLabel?
    var rect: CGRect?
    var rectS: CGRect?
    
    var m_buttonText: String?
    var m_textSize: CGFloat?
    var m_textColor: UIColor?
    var m_textColorS: UIColor?
    var m_textPos: CGPoint?
    var m_shadowOffset: CGFloat?
    var textZPos: CGFloat?
    
    var m_outlineColor: UIColor?
    var m_fillColor: UIColor?
    var rectLineWidth: CGFloat?
    var rectSLineWidth: CGFloat?
    
    let radius = 16
    let hor: SKLabelHorizontalAlignmentMode = .Center
    let vert: SKLabelVerticalAlignmentMode = .Baseline
    
    var rectZPos: CGFloat?
    var rectSZPos: CGFloat?
    
    var shade: SKShapeNode?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(buttonRect: CGRect, outlineColor: UIColor, fillColor: UIColor, lineWidth: CGFloat, startZ: CGFloat) {
            
            rect = buttonRect
            rectS = CGRect(x: buttonRect.minX, y: buttonRect.minY - 5, width: buttonRect.width, height: buttonRect.height)
            
            rectSZPos = startZ
            rectZPos = startZ + 1
            textZPos = startZ + 2
            
            //Rect Vars
            m_outlineColor = outlineColor
            m_fillColor = fillColor
            rectLineWidth = lineWidth
            rectSLineWidth = lineWidth*2
            
            super.init()
            
            CreateButtonRectShadow()
            CreateButtonRect()
    }
    
    private func CreateButtonLabel() {
        buttonLabel = GameLabel(text: m_buttonText!, size: m_textSize!,
            horAlignMode: hor, vertAlignMode: vert,
            color: m_textColor!, shadowColor: m_textColorS!, shadowOffset: m_shadowOffset!,
            pos: m_textPos!, zPosition: textZPos!)
        if let bl = buttonLabel {
            self.addChild(bl)
        }
    }
    
    private func CreateButtonRectShadow() {
        let m_rectS = getRoundedRectShape(rectS!, cornerRadius: 16, color: m_outlineColor!, lineWidth: rectSLineWidth!)
        m_rectS.fillColor = m_fillColor!
        m_rectS.zPosition = rectSZPos!
        addChild(m_rectS)
    }
    
    private func CreateButtonRect() {
        let m_rect = getRoundedRectShape(rect!, cornerRadius: 16, color: m_outlineColor!, lineWidth: rectLineWidth!)
        m_rect.fillColor = m_fillColor!
        m_rect.zPosition = rectZPos!
        addChild(m_rect)
    }
    
    func setText(buttonText: String, textSize: CGFloat, textColor: UIColor,
        textColorS: UIColor, textPos: CGPoint, shadowOffset: CGFloat) {
        //Label Vars
        m_buttonText = buttonText
        m_textSize = textSize
        m_textColor = textColor
        m_textColorS = textColorS
        m_textPos = textPos
        m_shadowOffset = shadowOffset
        
        CreateButtonLabel()
    }
    
    func click() {
        shade = drawRectangle(rect!, color: SKColor.grayColor(), width: 1.0)
        shade!.fillColor = SKColor.grayColor()
        shade!.alpha = 0.4
        shade!.zPosition = rectSZPos! + 3
        addChild(shade!)
    }
    
    func unclick() {
        shade!.removeFromParent()
    }
    
    func stretchText() {
        
    }

}


