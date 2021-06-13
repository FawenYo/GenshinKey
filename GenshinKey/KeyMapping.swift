//
//  Keymapping.swift
//  GenshinKey
//
//  Modified by FawenYo on 6/13/2021
//

import SwiftUI

func createKeybinding() {
    
    NSEvent.addGlobalMonitorForEvents(matching: [.keyDown]) { (event) in
        if (topmost == false) { return } // Only process inputs when Game is in focus
        
        switch (event.keyCode) {
        
        // keyCode: w == 13
        case (13):
            up = 1
            break
        // keyCode: s == 1
        case (1):
            down = 1
            break
        // keyCode: a == 0
        case (0):
            left = 1
            break
        // keyCode: d == 2
        case (2):
            right = 1
            break
        // keyCode: v == 9
        case (9):
            simulatePressDown(pos: ATTACK_BUTTON)
        // keyCode: e == 14
        case (14):
            simulatePressDown(pos: E_SKILL_BUTTON)
        // keyCode: q == 12
        case (12):
            simulatePressDown(pos: Q_SKILL_BUTTON)
        // keyCode: r == 15
        case (15):
            simulateClick(pos: RUN_BUTTON)
        // keyCode: space == 49
        case (49):
            simulateClick(pos: JUMP_BUTTON)
        // keyCode: esc == 53
        case (53):
            simulateClick(pos: ESC_BUTTON)
        // keyCode: j == 38
        case (38):
            simulateClick(pos: JOB_BUTTON)
        // keyCode: m == 46
        case (46):
            simulateClick(pos: MAP_BUTTON)
        // keyCode: b == 11
        case (11):
            simulateClick(pos: BACKPACK_BUTTON)
        // keyCode: c == 8
        case (8):
            simulateClick(pos: CHARACTERS_BUTTON)
        // keyCode: 1 == 18
        case (18):
            simulateClick(pos: CHARACTER_1_BUTTON)
        // keyCode: 2 == 19
        case (19):
            simulateClick(pos: CHARACTER_2_BUTTON)
        // keyCode: 3 == 20
        case (20):
            simulateClick(pos: CHARACTER_3_BUTTON)
        default:
            break
            
        }
    }
    
    NSEvent.addGlobalMonitorForEvents(matching: [.keyUp]) { (event) in
        
        if (topmost == false){ return } // Only process inputs when Game is in focus
        
        switch (event.keyCode) {
        
        // keyCode: w == 13
        case (13):
            up = 0
            break
        // keyCode: s == 1
        case (1):
            down = 0
            break
        // keyCode: a == 0
        case (0):
            left = 0
            break
        // keyCode: d == 2
        case (2):
            right = 0
            break
        // keyCode: v == 9
        case (9):
            simulatePressUp(pos: ATTACK_BUTTON)
        // keyCode: e == 14
        case (14):
            simulatePressUp(pos: E_SKILL_BUTTON)
        // keyCode: q == 12
        case (12):
            simulatePressUp(pos: Q_SKILL_BUTTON)
        default:
            break
        }
        moveMouse(pos: ATTACK_BUTTON)
    }
}
