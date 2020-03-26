//
//  StuCell.swift
//  Video Caught
//
//  Created by Tianxu Zhou on 2020/3/26.
//  Copyright © 2020 Tianxu Zhou. All rights reserved.
//

import SwiftUI
import AVFoundation

struct StuCell: View {
    var student: Student
    
    @Binding var meEmotion:Int
    @Binding var whichSoundOn:Int

    let soundTimer=Timer.publish(every: 1.2, on: .main, in: .common).autoconnect()
    let videoTimer=Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    let soundArray=[1,0,3,4,2]
    let audioPlayer = AVPlayer()
    let sounds=["cat.mp3"]
    
    @State var getCaught=false
    @State var audioOn=true
    @State var videoOn=false
    @State var isToggle=false
    
    // Play sound helper method.
    func playSound(filename: String) {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "") else { return }
        
        let playerItem = AVPlayerItem(url: url)
        audioPlayer.replaceCurrentItem(with: playerItem)
        audioPlayer.play()
    }
    
    var body: some View {
        
        ZStack{
            //            self.playSound(filename: "cat.mp3")
            Rectangle()
                .frame(width:178, height: 234)
                .border(Color(hex:0x979797), width: 1)
                .foregroundColor(Color.white.opacity(0))
            
            VStack(alignment: .center) {
                if !self.videoOn {
                    Text("\(student.name)")
                        .foregroundColor(Color(hex:0xFCFCFC))
                        .font(.system(size: 20, weight: .bold))
                    
                }else{
                    Text(self.getCaught ? "\(student.stustate.focusState)" : "\(student.stustate.emoji)")
                        .font(.system(size: 80, weight: .regular))
                    
                }
                
                
            }
            
            
            VStack(alignment: .leading){
                HStack() {
                    Button(action: {
                        self.audioOn.toggle()
                        if self.soundArray[self.whichSoundOn]==self.student.id{
                            
                            self.getCaught=true
                            
                            if self.whichSoundOn > -1 && self.whichSoundOn<5{
                                self.whichSoundOn+=1
                            }
                            if self.whichSoundOn==0{
                                self.meEmotion=0
                            } else if  self.whichSoundOn==4{
                                self.meEmotion=2
                            }else if self.whichSoundOn<4 && self.whichSoundOn>0{
                                self.meEmotion=1
                            }
                            
                        }
                    }){
                        Image(!self.audioOn ? "audioStop" : "audioStart")
                    }.buttonStyle(PlainButtonStyle())
                    Button(action: {self.videoOn.toggle()}){
                        Image(!self.videoOn ? "vidStop" : "vidStart")
                    }.buttonStyle(PlainButtonStyle())
                    
                    Spacer()
                }
            }.offset(y:CGFloat(90))
        } .onReceive(self.soundTimer){ _ in
            if self.audioOn && self.soundArray[self.whichSoundOn]==self.student.id && self.student.stustate.soundFile != ""{
                self.playSound(filename: "\(self.student.stustate.soundFile)")
            }
            
        }
            
        .onReceive(self.videoTimer){ _ in
            if !self.getCaught && (self.student.id-2) != 0 {
                self.videoOn=false
            }
            if self.getCaught{
                self.videoOn=true
            }
        }
    }
}



//struct StuCell_Previews: PreviewProvider {
//    static var previews: some View {
//        StuCell()
//    }
//}
