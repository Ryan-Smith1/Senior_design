//
//  Function_FaceID.swift
//  Security
//
//  Created by Ryan Smith on 1/10/24.
//
//credits for code -> https://www.hackingwithswift.com/books/ios-swiftui/using-touch-id-and-face-id-with-swiftui
/*
import Foundation
import LocalAuthentication

func authenticate(){
    let context = LAContext()
    var error: NSError?
    var _pass = 0
    if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
        let reason = "We need to unlock your data."

        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
            if success {isUnlocked = 2}//passed biametrics
            else { isUnlocked = 1}//failed biometrics
        }
    } 
    else { isUnlocked = 0}//no biametrics
}
*/

