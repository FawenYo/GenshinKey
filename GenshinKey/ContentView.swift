//
//  ContentView.swift
//  GenshinKey
//
//  Modified by FawenYo on 6/13/2021
//

import SwiftUI

class globaleState: ObservableObject {
    static let shared = globaleState()
    private init() {}
    @Published var gameName: String = "原神"
    @Published var download: String = ""
}

struct ContentView: View {
    @State private var latestVersion = true
    @State private var checkUpdate = false
    @Environment(\.openURL) var openURL
    @ObservedObject var state = globaleState.shared
   
    var body: some View {
        VStack {
            ZStack {
                Color.black
                    .edgesIgnoringSafeArea(.all)
                VStack (alignment: .leading, spacing: 6){
                    Group{
                        Text("Grant following permisions to GenshinKey")
                            .foregroundColor(.white)
                            .font(.title2)
                        Text("System prefrences > Security & Privacy >  Privacy")
                            .foregroundColor(.white)
                        Text("•Accessiblity")
                            .foregroundColor(.white)
                            .padding(.bottom)
                        }
                    Text("Author: FawenYo")
                        .foregroundColor(.white)
                        .font(.title3)
                }.padding()
            }
            HStack (alignment: .center, spacing: 6){
                Spacer()
                Text("視窗名稱")
                    .foregroundColor(.white)
                TextField("你的名字", text: $state.gameName)
                    .padding()
            }.padding()
            Button(action: {
                self.checkUpdate = false
                Update.checkForUpdate(completion: { download in
                    DispatchQueue.main.async {
                        if (download != "") {
                            latestVersion = false
                            state.download = download
                        }
                    }
                    self.checkUpdate.toggle()
                }
                )
            })
            {
                Text("Check for Update").font(.system(size: 24))
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color.white))
                    .frame(minWidth: 250)
            }
            .alert(isPresented: $checkUpdate) {
                if (self.latestVersion) {
                    return Alert(title: Text("You are using the latest version!"), dismissButton: .default(Text("OK")))
                } else {
                    return Alert(title: Text("New Update Available!"),
                                 primaryButton: .default(Text("Download"), action: {
                                    openURL(URL(string: self.state.download)!)
                                 }),
                                 secondaryButton: .default(Text("Ignore")))
                }
            }
            .buttonStyle(PlainButtonStyle())
            .padding()
        }.frame(minWidth: 500, maxWidth: 500, alignment: .topLeading).background(Color.black)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//Source: https://stackoverflow.com/a/59228385
extension View {
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
}
