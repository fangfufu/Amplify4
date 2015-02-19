//
//  AMGlobals.swift
//  Amplify4
//
//  Created by Bill Engels on 2/10/15.
//  Copyright (c) 2015 Bill Engels. All rights reserved.
//

import Cocoa

let globals = AMGlobals()

class AMGlobals: NSObject {
    let DNAConc = "DNAConc"
    let dimerOverlap = "dimerOverlap"
    let dimerStringency = "dimerStringency"
    let endHeader = "endHeader"
    let effectivePrimer = "effectivePrimer"
    let enthalpy = "enthalpy2"
    let entropy = "entropy2"
    let linearDefault = "linearDefault"
    let minOverlap = "minOverlap"
    let pairScores = "pairScores"
    let primabilityCutoff = "primabilityCutoff"
    let stabilityCutoff = "stabilityCutoff"
    let saltConc = "saltConc"
    let targetFont = "targetFont"
    let targetSize = "targetSize"
    let matchWeights = "matchWeights"
    let runWeights = "runWeights"
    let dimScores = "dimScores"
    let IUBString = "GATCMRWSYKVHDBN"
    let compIUBString = "CTAGKYWSRMBDHVN"
    let recentDocs = "recent Docs"
    
    let factory = NSDictionary(contentsOfFile: NSBundle.mainBundle().pathForResource("settings", ofType: "plist")!)!
}

func make2D(a : [Int], ncols : Int) -> [[Int]] {
    //This is an ugly workaround to make Swift convert an array of Int to a 2-dimensional one.
    var nrows = a.count/ncols
    if a.count % ncols > 0 {nrows++}
    var nara = [Int]()
    var a2 = [Array<Int>]()
    for i in 0..<nrows {
        nara.removeAll(keepCapacity: true)
        nara.splice(a[i*ncols...(i*ncols + ncols - 1)], atIndex: 0) // This is an awkward way to turn a Slice into an Array
        a2.append(nara);
    }
    return a2
}
