//
//  ContentView.swift
//  Timer
//
//  Created by Yanun on 2022/10/1.
//

import SwiftUI
import UIComponent
import AVFoundation


struct ContentView: View {
    @State var isCounting = false
    @State var isPause = false
    @State var timeLeft: Int = 0
    @State var timer: Timer? = nil
    
    @State var remainBlock: Int = 1
    
    var countdownSound = NSSound(named: .purr)
    var timeSound = NSSound(named: .glass)
    var stopSound = NSSound(named: .submarine)
    var pauseSound = NSSound(named: .frog)
    
    var body: some View {
        VStack {
            HStack(spacing: 10) {
                Text("Leetcode Timer")
                    .font(.title2)
                    .fontWeight(.medium)
                    .offset(y: 1)
                
                Focus()
                ButtonCustom(width: 25, height: 20, color: .red.opacity(0.9), radius: 4) {
                    NSApplication.shared.terminate(self)
                } content: {
                    Image(systemName: "power")
                        .font(.callout)
                        .foregroundColor(.white)
                }
            }
            .background(Color.transparent)
            .onTapGesture {
                #if DEBUG
                withAnimation(.easeInOut(duration: 0.3)) {
                    timeLeft = 10
                    isCounting = true
                    StartTimer()
                }
                #endif
            }
            
            Separator()
            StopBlock
            if isCounting {
                ProgressBlock
                    .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
        .padding(10)
        .background(Color.white)
    }
}

// MARK: Property
extension ContentView {
    var minute: String {
        let s = (timeLeft/60).format("02")
        return s.count < 2 ? "0"+s : s
    }
    
    var second: String {
        let s = (timeLeft%60).format("02")
        return s.count < 2 ? "0"+s : s
    }
}

// MARK: View
extension ContentView {
    var ProgressBlock: some View {
        VStack {
            HStack {
                Text("\(minute):\(second)")
                    .font(.system(size: 30))
                    .monospacedDigit()
            }
            Spacer()
            HStack {
                Spacer()
                ButtonCustom(width: 70, height: 25, color: .white, radius: 5, shadow: 1.2) {
                    PlaySound(stopSound)
                    Stop()
                } content: {
                    Image(systemName: "stop.fill")
                }
                Spacer()
                ButtonCustom(width: 70, height: 25, color: .white, radius: 5, shadow: 1.2) {
                    isPause.toggle()
                    isPause ? PlaySound(pauseSound) : PlaySound(timeSound)
                } content: {
                    Image(systemName: isPause ? "play.fill" : "pause.fill")
                }
                Spacer()
            }
            .padding(.bottom, 5)
        }
    }
    
    var StopBlock: some View {
        VStack {
            if !isCounting || remainBlock == 1 {
                TimerButton(title: "Easy", subtitle: "10 minutes", color: .green) {
                    PlaySound(timeSound)
                    timeLeft = 600
                    remainBlock = 1
                    isCounting = true
                    StartTimer()
                }
            }
            if !isCounting || remainBlock == 2 {
                TimerButton(title: "Medium", subtitle: "20 minutes", color: .yellow) {
                    PlaySound(timeSound)
                    timeLeft = 1200
                    remainBlock = 2
                    isCounting = true
                    StartTimer()
                }
            }
            if !isCounting || remainBlock == 3 {
                TimerButton(title: "Hard", subtitle: "30 minutes", color: .red) {
                    PlaySound(timeSound)
                    timeLeft = 1800
                    remainBlock = 3
                    isCounting = true
                    StartTimer()
                }
            }
        }
    }
    
    func TimerButton(title: String, subtitle: String, color: Color, action: @escaping () -> Void) -> some View {
        RoundedRectangle(cornerRadius: 5)
            .foregroundColor(.transparent)
            .overlay {
                VStack {
                    Text(title)
                        .font(.system(size: 30, weight: .light))
                        .foregroundColor(color)
                    Text(subtitle)
                        .foregroundColor(.primary50)
                        .fontWeight(.light)
                }
            }
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.3)) {
                    action()
                }
            }
            .disabled(isCounting)
    }
}

// MARK: Method
extension ContentView {
    func StartTimer() {
        print("start!!")
        timer = .scheduledTimer(withTimeInterval: 1, repeats: true, block: { t in
            if isPause {
                return
            }
            if timeLeft > 0 {
                timeLeft -= 1
            }
            
            if timeLeft <= 5 && timeLeft > 0 {
                PlaySound(countdownSound)
            }
            
            if timeLeft == 1 {
                PlayLoopSound(timeSound)
            }
            
            if timeLeft < 1 {
                Stop()
            }
        })
    }
    
    func PlaySound(_ sound: NSSound?) {
        sound?.stop()
        sound?.play()
    }
    
    func PlayLoopSound(_ sound: NSSound?) {
        var time = 3
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { t in
            if time > 0 {
                Alarm(sound)
                time -= 1
                return
            }
            t.invalidate()
        }
    }
    
    func Alarm(_ sound: NSSound?) {
        var time = 2
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { t in
            if time > 0 {
                PlaySound(sound)
                time -= 1
                return
            }
            t.invalidate()
        }
    }
    
    func Stop() {
        withAnimation(.easeInOut(duration: 0.3)) {
            isCounting = false
            isPause = false
            timer?.invalidate()
            print("stop!!")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .frame(width: 200, height: 300)
    }
}

public extension NSSound.Name {
    static let basso     = NSSound.Name("Basso")
    static let blow      = NSSound.Name("Blow") // OK
    static let bottle    = NSSound.Name("Bottle")
    static let frog      = NSSound.Name("Frog")
    static let funk      = NSSound.Name("Funk")
    static let glass     = NSSound.Name("Glass") // OK
    static let hero      = NSSound.Name("Hero")
    static let morse     = NSSound.Name("Morse")
    static let ping      = NSSound.Name("Ping")
    static let pop       = NSSound.Name("Pop")
    static let purr      = NSSound.Name("Purr") // 倒數可以用
    static let sosumi    = NSSound.Name("Sosumi")
    static let submarine = NSSound.Name("Submarine")
    static let tink      = NSSound.Name("Tink")
}
