import Foundation
import SwiftUI

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}


struct ScrollMagic: View {

    @State private var multiplicator: CGFloat = 1
    @State private var isLarge = false

    var body: some View {
         VStack{
             if isLarge {
                VStack(alignment: .center, spacing: 0) {
                    Spacer()
                    HStack(alignment: .center, spacing: 0) {
                        Spacer()
                        Text("Alexis Grigorev")
                        .font(.system(size: 40))
                        Spacer()
                    }
                    Spacer()
                }
                        .background(Color.yellow)
                        .frame(width: .infinity, height: 244)
                        .transition(.scale)
             } else {
                 Text("AG").font(.system(size: 78 * multiplicator))
                         .fixedSize()
                         .padding(50 * multiplicator)
                         .background(Color.yellow)
                         .clipShape(Circle())
                         .padding(.top, 44)
                         .transition(.scale)
             }


             scrollView
                    .background(Color.red)
                     .onPreferenceChange(OffsetKey.self, perform: onPrefChange)

         }.edgesIgnoringSafeArea(.all)
    }

    private var scrollView: some View {
        GeometryReader { g in
            ScrollView(.vertical) {
                scrollableContent
                        .anchorPreference(key: OffsetKey.self, value: .top) {
                            g[$0].y
                        }
                .transition(.identity)
            }
        }
    }

    private var scrollableContent: some View {
        Group {
            ForEach(1...100, id: \.self) { i in
                HStack {
                    Text("text item: \(i)").font(.system(.body))
                    Spacer()
                }.padding()
            }
        }
    }

    private func onPrefChange(_ pref: CGFloat) {
        guard pref != 0 && abs(pref) != .infinity else {
            return
        }
        print(pref)

        if pref >= 0 {
            multiplicator = 1
            if pref > 30 {
                isLarge = true
            }
            return
        }
        if isLarge && abs(pref) > 30 {
            isLarge = false
            return
        }

        let step: CGFloat = 250
        let delta = abs(pref) / step
        let newMultiplicator = max(1 - delta, 0.33)
        if abs(multiplicator - newMultiplicator) > 0.01 {
            multiplicator = newMultiplicator
        }
    }
}