//
//  ContentView.swift
//  FormantBuilder
//
//  Created by ookamitai on 8/5/24.
//

import SwiftUI
import Python
import PythonKit

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @State private var imagePath: String = ""
    @State private var tubeID: Int = 1
    @State private var repeatString: String = "50"
    @State private var repeatNum: Int = 50
    @State private var length: [Double] = [13, 13, 13, 13]
    @State private var area: [Double] = [10, 10, 10, 10]
    @State private var finishedText: String = ""
//    @State private var useNewTube: Bool = false
//    @State private var freqString: String = "440"
//    @State private var freq: Int = 440
//    @State private var octaveString: String = "2"
//    @State private var octave: Int = 2
    private var audioHandler: AudioHandler = AudioHandler()
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("4 tube model test")
                        .font(.title)
                    Divider()
                    Text("is Python ready? \(appState.isPythonReady)")
                    Text("Python ver = \(Python.import("sys").version_info.major).\(Python.import("sys").version_info.minor)")
                    Text("[lib] numpy = \(Python.import("numpy").__version__)")
                    Text("[lib] matplotlib = \(Python.import("matplotlib").__version__)")
                    Text("[lib] scipy = \(Python.import("scipy").__version__)")
//                    Toggle(isOn: $useNewTube) {
//                        Text("use experimental tube")
//                    }
                    Picker("tubeid", selection: $tubeID) {
                        Text("a")
                            .tag(1)
                        Text("i")
                            .tag(2)
                        Text("u")
                            .tag(3)
                        Text("e")
                            .tag(4)
                        Text("o")
                            .tag(5)
                        Text("custom")
                            .tag(0)
                    }
                    TextField("repeat num", text: $repeatString)
                        .onSubmit {
                            repeatNum = Int(repeatString) ?? repeatNum
                        }
                    Spacer()
                }
                Divider()
                VStack(alignment: .leading) {
                    HStack {
                        Text("length 1 (cm)")
                        Slider(value: $length[0], in: 1.0...20.0)
                        Text("\(length[0])")
                    }
                    HStack {
                        Text("length 2 (cm)")
                        Slider(value: $length[1], in: 1.0...20.0)
                        Text("\(length[1])")
                    }
                    HStack {
                        Text("length 3 (cm)")
                        Slider(value: $length[2], in: 1.0...20.0)
                        Text("\(length[2])")
                    }
                    HStack {
                        Text("length 4 (cm)")
                        Slider(value: $length[3], in: 1.0...20.0)
                        Text("\(length[3])")
                    }
                    
                    HStack {
                        Text("area 1 (cm^2)")
                        Slider(value: $area[0], in: 0.1...80.0)
                        Text("\(area[0])")
                    }
                    HStack {
                        Text("area 2 (cm^2)")
                        Slider(value: $area[1], in: 0.1...80.0)
                        Text("\(area[1])")
                    }
                    HStack {
                        Text("area 3 (cm^2)")
                        Slider(value: $area[2], in: 0.1...80.0)
                        Text("\(area[2])")
                    }
                    HStack {
                        Text("area 4 (cm^2)")
                        Slider(value: $area[3], in: 0.1...80.0)
                        Text("\(area[3])")
                    }
                    Spacer()
                }
                .disabled(tubeID != 0)
            }
            AsyncImage(url: URL(filePath: imagePath))
            HStack {
                Button {
                    if let path = Bundle.main.url(forResource: "Scripts/main5", withExtension: "py") {
                        if tubeID == 1 {
                            length[0] = 3.698116068094256
                            length[1] = 5.565020169379425
                            length[2] = 6.962391846610267
                            length[3] = 2.174272784424185
                            area[0] = 1.0
                            area[1] = 1.7610962103700538
                            area[2] = 68.3470685620078
                            area[3] = 25.182712939573886
                        } else if tubeID == 2{
                            length[0] = 4.56435574101474
                            length[1] = 1.5815494971271784
                            length[2] = 6.3148516398884045
                            length[3] = 2.8913186253612144
                            area[0] = 12.4861116217549
                            area[1] = 6.577432646215859
                            area[2] = 1.0
                            area[3] = 15.866583995276608
                        } else if tubeID == 3 {
                            length[0] = 3.7194986326972943
                            length[1] = 1.888224862637144
                            length[2] = 7.276399617568311
                            length[3] = 5.535507523773382
                            area[0] = 4.594948652925214
                            area[1] = 1.7371607940258063
                            area[2] = 7.012233492843109
                            area[3] = 1.0
                        } else if tubeID == 4 {
                            length[0] = 3.258269263264273
                            length[1] = 4.936530924286407
                            length[2] = 1.6678711570315916
                            length[3] = 6.582655113007322
                            area[0] = 1.0
                            area[1] = 18.982925503761678
                            area[2] = 10.180643942459346
                            area[3] = 5.498047801381349
                        } else if tubeID == 5 {
                            length[0] = 7.3000028311309855
                            length[1] = 1.7642328995769578
                            length[2] = 3.7752944411902947
                            length[3] = 5.694868790881701
                            area[0] = 4.09498075759286
                            area[1] = 1.0
                            area[2] = 23.411325990169203
                            area[3] = 5.533790103661377
                        }
                        let main = getPythonScriptObject(path.path())
                        main.main(tubeID, length[0], length[1], length[2], length[3], area[0], area[1], area[2], area[3], repeatNum)
                        finishedText = "tubeid: \(tubeID) done"
                    }
                } label: {
                    Text("build")
                }
                Button {
                    imagePath = NSHomeDirectory() + "/\(tubeID).png"
                } label: {
                    Text("load img")
                }
                Button {
                    audioHandler.playSound(NSHomeDirectory() + "/wav/tube_5p\(tubeID).wav")
                } label: {
                    Text("play wav")
                }
                Text(finishedText)
            }
        }
        .padding()
        .onAppear {
            printPythonInfo()
            appState.isPythonReady = true
        }
    }
}

#Preview {
    ContentView()
}
