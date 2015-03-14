//
//  Fragment.swift
//  Amplify4
//
//  Created by Bill Engels on 3/5/15.
//  Copyright (c) 2015 Bill Engels. All rights reserved.
//

import Cocoa

class Fragment: MapItem {
    let dmatch, gmatch : Match
    let ampSize, totSize : Int
    let quality : CGFloat
    let barRect : NSRect
    let maxWidth : CGFloat = 10
    let widthCutoffs : [CGFloat] = [100, 200, 300, 500, 700, 1000, 1500, 2000, 3000, 4000, 7000, 10000]
    
    init(dmatch : Match, gmatch : Match) {
        self.dmatch = dmatch
        self.gmatch = gmatch
        self.ampSize = gmatch.threePrime - dmatch.threePrime - 1
        self.totSize = countElements(dmatch.primer.seq) + ampSize + countElements(gmatch.primer.seq)
        self.quality = dmatch.quality() * gmatch.quality()
        if quality > 0 {
            self.quality = CGFloat(ampSize)/(quality * quality)
        } else {
            quality = 5000000000
        }
        let widthIncrement = maxWidth / (CGFloat(widthCutoffs.count) + 1)
        var barWidth = maxWidth
        for w in widthCutoffs {
            if quality > w {barWidth -= widthIncrement}
        }
        self.barRect = NSRect(origin: NSPoint(x: 0, y: 0), size: NSSize(width: CGFloat(gmatch.threePrime - dmatch.threePrime), height: barWidth))
    }
    
    func setLitRec (rect : NSRect) {
        self.litBez = NSBezierPath(rect: NSInsetRect(rect, -5, 0))
        var move = NSAffineTransform()
        move.translateXBy(highlightPoint.x, yBy: highlightPoint.y)
        self.litBez.transformUsingAffineTransform(move)
        litBez.lineWidth =   highlightLineWidth
        self.coItems = [dmatch, gmatch]
        dmatch.coItems.append(self)
        gmatch.coItems.append(self)
    }
    
    override func info() -> NSAttributedString {
        var info = NSMutableAttributedString(string: "Fragment of total length: \(totSize) bp   ", attributes: fmat.normal)
        extendString(starter: info, suffix1:  "⫸(primer: ", attr1: fmat.normal, suffix2: dmatch.primer.name, attr2: fmat.bigboldblue)
        extendString(starter: info, suffix1: ") — \(ampSize) bp — (primer: ", attr1: fmat.normal, suffix2: gmatch.primer.name, attr2: fmat.bigboldred)
        extendString(starter: info, suffix: ")⫷", attr: fmat.normal)
        
        var description : String = "(very weak)"
        if quality < 4000 {description = "(weak)"}
        if quality < 1500 {description = "(moderate)"}
        if quality < 700 {description = "(okay)"}
        if quality < 300 {description = "(good)"}
        extendString(starter: info, suffix: String(format: "         Q = %.1f  %@", Double(quality), description), attr: fmat.normal);

        return info
    }

    override func report() -> NSAttributedString {
        var report = NSMutableAttributedString(string: "\r", attributes: fmat.hline1)
        let apdel = NSApplication.sharedApplication().delegate! as AppDelegate
        let targFileString = apdel.substrateDelegate.targetView.textStorage!.string as NSString
        let firstbase = apdel.targDelegate.firstbase as Int
        let targString = targFileString.substringFromIndex(firstbase).uppercaseString as NSString
        extendString(starter: report, suffix: "Amplified fragment of length \(totSize) bp\r", attr: fmat.h3)
        extendString(starter: report, suffix1:  "\r⫸(primer: ", attr1: fmat.normal, suffix2: dmatch.primer.name, attr2: fmat.blue)
        extendString(starter: report, suffix1: ") — \(ampSize) bp — (primer: ", attr1: fmat.normal, suffix2: gmatch.primer.name, attr2: fmat.red)
        extendString(starter: report, suffix: ")⫷", attr: fmat.normal)
        var description : String = "(very weak amplification — probably not visible on an agarose gel)"
        if quality < 4000 {description = "(weak amplification — might be visible on an agarose gel)"}
        if quality < 1500 {description = "(moderate amplification)"}
        if quality < 700 {description = "(okay amplification)"}
        if quality < 300 {description = "(good amplification)"}

        
        extendString(starter: report, suffix: String(format: "         Q = %.1f  %@\r\r", Double(quality), description), attr: fmat.normal)
        var gseq = ""
        for c in gmatch.primer.seq {
            gseq = apdel.substrateDelegate.iubComp(String(c)) + gseq
        }
        var ampSeq = NSMutableAttributedString(string: dmatch.primer.seq.lowercaseString, attributes: fmat.blueseq)
        let ampBases = targString.substringWithRange(NSMakeRange(dmatch.threePrime + 1, ampSize)).uppercaseString
        extendString(starter: ampSeq, suffix1: ampBases, attr1: fmat.seq, suffix2: gseq.lowercaseString, attr2: fmat.redseq)
        extendString(starter: report, suffix: "Amplified sequence: \r", attr: fmat.normal)
        report.appendAttributedString(ampSeq)
        extendString(starter: report, suffix: "\r\r", attr: fmat.normal)
        
        return report
    }

}
