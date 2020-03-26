//
//  ContentView.swift
//  Video Caught
//
//  Created by Tianxu Zhou on 2020/3/25.
//  Copyright © 2020 Tianxu Zhou. All rights reserved.
//

import SwiftUI
import AVFoundation

extension Color {
    init(hex: Int, alpha: Double = 1) {
        let components = (
            R: Double((hex >> 16) & 0xff) / 255,
            G: Double((hex >> 08) & 0xff) / 255,
            B: Double((hex >> 00) & 0xff) / 255
        )
        self.init(
            .sRGB,
            red: components.R,
            green: components.G,
            blue: components.B,
            opacity: alpha
        )
    }
}


struct Student {
    var name: String
    var id : Int
    var stustate: Stustate
}
struct Stustate {
    var emoji: String
    var caughtReaction: String
    var focusState:String
    
    var soundFile: String
}

class AppModel: ObservableObject {
    var students = [Student]()
    
    init() {
        let state1 = Stustate(emoji: "😪", caughtReaction: "😅", focusState: "🙋‍♂️", soundFile: "snoring.mp3")
        let student1 = Student(name: "Mike",id: 0, stustate: state1)
        students.append(student1)
        
        let state2 = Stustate(emoji: "🐱", caughtReaction: "😅", focusState: "🙋‍♀️", soundFile: "cat.mp3")
        let student2 = Student(name: "Jenny", id: 1,stustate: state2)
        students.append(student2)
        
        let state3 = Stustate(emoji: "🙋‍♀️", caughtReaction: "🙋‍♀️", focusState: "🙋‍♀️", soundFile: "")
        let student3 = Student(name: "Eva",id: 2, stustate: state3)
        students.append(student3)
        
        let state4 = Stustate(emoji: "🥤", caughtReaction: "😅", focusState: "🙋‍♂️", soundFile: "drinks.mp3")
        let student4 = Student(name: "Michael",id: 3, stustate: state4)
        students.append(student4)
        
        let state5 = Stustate(emoji: "🤳", caughtReaction: "😅", focusState: "🙋‍♂️", soundFile: "msg.mp3")
        let student5 = Student(name: "Dan",id: 4, stustate: state5)
        students.append(student5)
        
    }
}


struct ContentView: View {
    
    @State var meEmotion = 0
    @State var whichSoundOn = 0
    @ObservedObject var appModel = AppModel()
    //@State var isDrop=false
    
    let shuffleTimer=Timer.publish(every: 4, on: .main, in: .common).autoconnect()
    let randomTimer=Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    let meEmojis=["😡","😐","🙂"]
    
    let cardFrameColor=Color(hex:0x979797)
    let audioPlayer = AVPlayer()
    
    // Play sound helper method.
    func playSound(filename: String) {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "") else { return }
        
        let playerItem = AVPlayerItem(url: url)
        audioPlayer.replaceCurrentItem(with: playerItem)
        audioPlayer.play()
    }
    
    var body: some View {
        ZStack{
            Color(hex: 0x1F1F1F)
                .edgesIgnoringSafeArea(.all)
            VStack{
                
                ZStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            //drop students
                            //                            ForEach(appModel.students.dropFirst( self.isDrop ? 3: 0), id: \.name) { student in
                            //                                StuCell(student:student)
                            //
                            //                            }
                            ForEach(appModel.students, id: \.name) { student in
                                StuCell(student:student,meEmotion: self.$meEmotion,whichSoundOn: self.$whichSoundOn)
                                
                            }
                        }
                    }
                }
                
                ZStack{
                    Rectangle()
                        .frame(width:412, height: 480)
                        .border(Color(hex:0x979797), width: 1)
                        .foregroundColor(Color.white.opacity(0))
                    
                    Text("\(self.meEmojis[self.meEmotion])")
                        .font(.system(size: 100, weight: .regular))
                }.offset(y:30)
                
            }
        }.onAppear() {
            do {
                // Override device mute control.
                try AVAudioSession.sharedInstance().setCategory(.playback)
            } catch(let error) {
                print(error.localizedDescription)
            }
        }
//        .onReceive(self.randomTimer){ _ in
//            self.whichSoundOn=Int.random(in: 0..<5)
//        }
        //drop students
        //        .onReceive(self.shuffleTimer){ _ in
        //            self.isDrop.toggle()
        //        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
