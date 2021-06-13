//
//  GenshinKeyApp.swift
//  GenshinKey
//
//  Modified by FawenYo on 6/13/2021
//

import SwiftUI

@main
struct GenshinKeyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().onAppear(perform: {
                setup()
            })
        }
    }
}

var up: Int = 0
var down: Int = 0
var left: Int = 0
var right: Int = 0

var mouseIsDown: Bool = false;

let JOYSTICK = (x: 440.0, y: 1740.0)
let RUN_BUTTON = (x: 2580.0, y: 1873.0)
let JUMP_BUTTON = (x: 2580.0, y: 1550.0)
let ATTACK_BUTTON = (x: 2315.0, y: 1730.0)
let E_SKILL_BUTTON = (x: 2050.0, y: 1873.0)
let Q_SKILL_BUTTON = (x: 1800.0, y: 1950.0)
let ESC_BUTTON = (x: 100.0, y: 80.0)
let JOB_BUTTON = (x: 100.0, y: 350.0)
let MAP_BUTTON = (x: 300.0, y: 230.0)
let BACKPACK_BUTTON = (x: 2500.0, y:80.0)
let CHARACTERS_BUTTON = (x: 2670.0, y:80.0)
let CHARACTER_1_BUTTON = (x: 2670.0, y:870.0)
let CHARACTER_2_BUTTON = (x: 2670.0, y:1040.0)
let CHARACTER_3_BUTTON = (x: 2670.0, y:1200.0)

var originalPosition = (x: 0.0, y: 0.0)
var originalSize = (height: 0.0, width: 0.0)

var X: Double = -1.0 // X Position of the Genshin Window
var Y: Double = -1.0 // Y Position of the Genshin Window

var Height: Double = -1 // Height of the Genshin Window
var Width: Double = -1 // Width of the Genshin Window

var topmost: Bool = false // Is Genshin in focus

var lastX: Double = 0.0 // Last down X position of cursor
var lastY: Double = 0.0 // Last down Y position of cursor

func setup() {
    let permission = AXIsProcessTrustedWithOptions([kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true] as CFDictionary)
    
    if (permission) {
        createKeybinding()
    }
    
    //Run movment all 25ms
    Timer.scheduledTimer(withTimeInterval: 0.025, repeats: true) { _ in
        movement()
    }

    //Caputre Genshin window all 250ms
    Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { _ in
        gameWindow()
    }
}


func movement() {
    if (X == -1 && Y == -1) { rescueMouse(); return }

    if (topmost == false) { rescueMouse(); return }

    if ((up + down + left + right) == 0) { rescueMouse(); return }
    
    var joystickY: Double = calcPos(pos: JOYSTICK).y
    var joystickX: Double = calcPos(pos: JOYSTICK).x

    if (mouseIsDown == false) {
        // Set cursor in the center of the Joystick
        mouseDown(pos: CGPoint(x: X + calcPos(pos: JOYSTICK).x, y: Y + calcPos(pos: JOYSTICK).y));
    }
    
    // Set the cursor to the movemment direction
    joystickY = joystickY - (joysticDistance() * Double(up));
    joystickY = joystickY + (joysticDistance() * Double(down));
    joystickX = joystickX - (joysticDistance() * Double(left));
    joystickX = joystickX + (joysticDistance() * Double(right));

    lastX = X + joystickX
    lastY = Y + joystickY

    mouseDown(pos: CGPoint(x: lastX, y: lastY));
    mouseIsDown = true
}

func calcPos(pos: (x: Double, y: Double)) -> (x: Double, y: Double) {
    return (x: pos.x / (2800.0 / Width), y: pos.y / (2100 / Height))
}

func joysticDistance() -> Double {
    return 120 / (2800.0 / Width)
}

func gameWindow() {
    let options = CGWindowListOption(arrayLiteral: CGWindowListOption.optionAll)
    let cgWindowListInfo = CGWindowListCopyWindowInfo(options, CGWindowID(0))
    let cgWindowListInfo2 = cgWindowListInfo as NSArray? as? [[String: AnyObject]]
    let frontMostAppId = NSWorkspace.shared.frontmostApplication!.processIdentifier
   
    for windowDic in cgWindowListInfo2! {
        // Determine the Genshin window
        if (windowDic["kCGWindowOwnerName"] as! String == globaleState.shared.gameName && windowDic["kCGWindowStoreType"] as! Int == 1 && windowDic["kCGWindowAlpha"] as! Int == 1) {
            let ownerProcessID = windowDic["kCGWindowOwnerPID"] as! Int
            let bounds = windowDic["kCGWindowBounds"] as! [String: Double]
            
            if (bounds["Height"]! <= 500 || bounds["Width"]! <= 500) { return } //Fix for Macs with Touchbar
        
            originalPosition = (x: bounds["X"]!, y: bounds["Y"]!)
            originalSize = (height: bounds["Height"]!, width: bounds["Width"]!)
            
            X = originalPosition.x
            Y = originalPosition.y
            Height = originalSize.height
            Width = originalSize.width
            
            if (isFullscreen()) {
                let f = 2800.0 / 2100.0
                X = (Width - (Height * f)) / 2.0
                Y = 0.167 
                Width = (Height * f)
            }else{
                Y = Y + 29 // Window Topbar
                Height = Height - 29 // Window Topbar
            }
            
            topmost = (frontMostAppId == ownerProcessID)
        }
    }
}

func isFullscreen() -> Bool {
    return (originalSize.height > 619 && originalPosition.x == 0.0 && originalPosition.y == 0.0)
}

func rescueMouse() {
    if (mouseIsDown == true) {
        mouseUp(pos: CGPoint(x: lastX, y: lastY));
        mouseIsDown = false;
    }
}

func simulateKeypress(key: UInt16) {
   print("Keypress: " + String(key))
   let keyDownEvent = CGEvent(keyboardEventSource: nil, virtualKey: key, keyDown: true)
   keyDownEvent?.flags = CGEventFlags.maskCommand
   keyDownEvent?.post(tap: CGEventTapLocation.cghidEventTap)
}

func simulateClick(pos: (x: Double, y: Double)) {
    if (X == -1 && Y == -1) {
        return;
    }
    let pos = CGPoint(x: X + calcPos(pos: pos).x, y: Y + calcPos(pos: pos).y)
    rescueMouse()
    usleep(50000)
    mouseDown(pos: pos)
    usleep(50000)
    mouseUp(pos: pos)
}

func simulatePressDown(pos: (x: Double, y: Double)) {
    if (X == -1 && Y == -1) {
        return;
    }
    let pos = CGPoint(x: X + calcPos(pos: pos).x, y: Y + calcPos(pos: pos).y)
    rescueMouse()
    usleep(50000)
    mouseDown(pos: pos)
}

func simulatePressUp(pos: (x: Double, y: Double)) {
    if (X == -1 && Y == -1) {
        return;
    }
    let pos = CGPoint(x: X + calcPos(pos: pos).x, y: Y + calcPos(pos: pos).y)
    rescueMouse()
    usleep(50000)
    mouseUp(pos: pos)
}

func mouseDown(pos: CGPoint) {
    let mouseDown = CGEvent(mouseEventSource: CGEventSource.init(stateID: .hidSystemState), mouseType: .leftMouseDown,
    mouseCursorPosition: pos, mouseButton: .left)
    
    mouseDown?.post(tap: .cghidEventTap)
}

func mouseUp(pos: CGPoint) {
    let mouseEventUp = CGEvent(mouseEventSource: CGEventSource.init(stateID: .hidSystemState), mouseType: .leftMouseUp,
    mouseCursorPosition: pos, mouseButton: .left)
    
    mouseEventUp?.post(tap: .cghidEventTap)
}

func moveMouse(pos: (x: Double, y: Double)) {
    if (X == -1 && Y == -1) {
        return;
    }
    let pos = CGPoint(x: X + calcPos(pos: pos).x, y: Y + calcPos(pos: pos).y)
    rescueMouse()
    usleep(50000)
    mouseUp(pos: pos)
}
