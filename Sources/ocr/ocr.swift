import Foundation
import Vision
import ArgumentParser

@main
struct OCR: ParsableCommand {

  @Flag
  var showSupportedLanguages: Bool = false

  @Flag
  var verbose: Bool = false

  @Option
  var lang: String?

  @Argument
  var imagePath: String?

  func validate() throws {
    if imagePath == nil {
      throw ArgumentError.argumentRequired
    }
  }

  func run() throws {
   let request = VNRecognizeTextRequest() { request, error in
     if error != nil {
       print("\(String(describing: error))")
       return
     }

     guard let request = request as? VNRecognizeTextRequest else {
       return
     }

     guard let results = request.results, !results.isEmpty else {
       return
     }

     results.forEach { obv in
       guard let text = obv.topCandidates(1).first?.string else {
         return
       }
       print(String(describing: text))
     }
   }

   if showSupportedLanguages {
     print((try? request.supportedRecognitionLanguages()) ?? [])
     return
   }

   request.recognitionLevel = .accurate
   request.revision = VNRecognizeTextRequestRevision2

   if let lang = lang {
     let langs = (lang as NSString).components(separatedBy: " ")
     if verbose == true {
       print("langs \(langs)")
     }
     request.recognitionLanguages = langs
   }

   guard FileManager.default.fileExists(atPath: imagePath!) else {
     throw ArgumentError.fileNotExist
   }

   let url = NSURL(fileURLWithPath: imagePath!) as URL
   try! VNImageRequestHandler(url: url).perform([request])
  }

}

extension OCR {
  enum ArgumentError: Error {
    case argumentRequired
    case fileNotExist
  }
}
