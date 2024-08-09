//
//  PythonHandler.swift
//  FormantBuilder
//
//  Created by ookamitai on 8/5/24.
//

import Foundation
import PythonKit
import Python

func initPython() {
    guard let stdLibPath = Bundle.main.path(forResource: "python-stdlib", ofType: nil) else { return }
    guard let libDynloadPath = Bundle.main.path(forResource: "python-stdlib/lib-dynload", ofType: nil) else { return }
    setenv("PYTHONHOME", stdLibPath, 1)
    setenv("PYTHONPATH", "\(stdLibPath):\(libDynloadPath)", 1)
    Py_Initialize()
}

func printPythonInfo() {
    let sys = Python.import("sys")
    print("Python Version: \(sys.version_info.major).\(sys.version_info.minor)")
    print("Python Encoding: \(sys.getdefaultencoding().upper())")
    print("Python Path: \(sys.path)")

    _ = Python.import("math")
}

func getDir(_ s: String) -> (String, String) {
    var a = s.components(separatedBy: "/")
    var n = a.popLast() ?? ""
    n = n.components(separatedBy: ".").first ?? ""
    var r = ""
    for i in a {
        r += (i + "/")
    }
    r.removeLast()
    return (r, n)
}

func getPythonScriptObject(_ name: String) -> PythonObject {
    // assuming there is a main() driver code
    let sys = Python.import("sys")
    let (dir, n) = getDir(name)
    print("Attemping to run script \(n).py...")
    sys.path.insert(1, dir)
    return Python.import(n)
}
