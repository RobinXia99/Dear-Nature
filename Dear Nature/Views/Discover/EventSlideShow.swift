//
//  EventSlideShow.swift
//  Dear Nature
//
//  Created by Robin Xia on 2022-02-07.
//

import SwiftUI

struct EventSlideShow: View {
    
    @StateObject var eventViewModel = EventViewModel()
    @State var currentIndex = 0
    private let timer = Timer.publish(every: 4, on: .main, in: .common).autoconnect()
    
    var body: some View {
                TabView(selection: $currentIndex) {
                ForEach(0..<eventViewModel.events.count) { i in

                    ZStack {
                        
                        Image("\(eventViewModel.events[i].image)")
                                .resizable()
                                .scaledToFill()
                        
                    }
                    
                }
            }.tabViewStyle(PageTabViewStyle())
                    .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height * 0.25)
                    .onReceive(timer, perform: { _ in
                        withAnimation {
                            currentIndex = currentIndex < eventViewModel.events.count ? currentIndex + 1 : 0
                        }
                    })
                
        
        
        
    }
}



struct EventSlideShow_Previews: PreviewProvider {
    static var previews: some View {
        EventSlideShow()
    }
}
