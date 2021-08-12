//
//  SanpCarousel.swift
//  SanpCarousel
//
//  Created by Michele Manniello on 12/08/21.
//

import SwiftUI

//To for Acception List....

struct SanpCarousel<Content: View, T: Identifiable>: View {
    var content: (T) -> Content
    var list : [T]
    
//    Properties...
    var spacing: CGFloat
    var trailingSpace : CGFloat
    @Binding var index : Int
    
    init(spacing: CGFloat = 15, trailingSpace : CGFloat = 100,index: Binding<Int>,items: [T], @ViewBuilder content: @escaping (T) -> Content){
        self.list = items
        self.spacing = spacing
        self.trailingSpace = trailingSpace
        self._index = index
        self.content = content
    }
//    Offset..
    @GestureState var offset : CGFloat = 0
    @State var currentIndex : Int = 0
    
    var body: some View{
        GeometryReader{ proxy in
            
//      Setting correct width for snap Carousel...
//            One Sided Sanp Caorusel...
            
            let width = proxy.size.width - (trailingSpace - spacing)
            let adjustMetWidth = (trailingSpace / 2) - spacing
            
            HStack(spacing: spacing) {
                ForEach(list){ item in
                    content(item)
                        .frame(width: proxy.size.width - trailingSpace)
                }
            }
//            spacing will be horzontal padding...
            .padding(.horizontal,spacing)
//            settings only after 0th index...
            .offset(x:(CGFloat(currentIndex) * -width) + (currentIndex != 0 ? adjustMetWidth : 0) + offset)
            .gesture(
                DragGesture()
                    .updating($offset,body: { value, out, _ in
                        out = value.translation.width
                    })
                    .onEnded({ value in
//                        Updating Current Index...
                        let offsetX = value.translation.width
//                        were going to convert the tranlation into progress (0 - 1)
//                        and round the value...
//                        based on the progress increasing or decreasng the currentIndex....
                        let progress = -offsetX / width
                        let roundIndex = progress.rounded()
                        currentIndex = max(min(currentIndex + Int(roundIndex), list.count - 1),0)
//                        updating index...
                        currentIndex = index
                    })
                    .onChanged({ value in
                        //                        updating only index...
                        
                        let offsetX = value.translation.width
                        //                        were going to convert the tranlation into progress (0 - 1)
                        //                        and round the value...
                        //                        based on the progress increasing or decreasng the currentIndex....
                        let progress = -offsetX / width
                        let roundIndex = progress.rounded()
                        index = max(min(currentIndex + Int(roundIndex), list.count - 1),0)
                    })
            )
            
        }
//        Animatiing when offset = 0
        .animation(.easeInOut, value: offset == 0)
    }
}

struct SanpCarousel_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
