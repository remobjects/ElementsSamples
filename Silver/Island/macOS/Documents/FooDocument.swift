﻿import Foundation
import AppKit

@objc public class FooDocument : NSDocument {

	//
	// NSDocument implementation
	//

	override init(type: String?, error: UnsafePointer<NSError>) { // workaround for invalid NSError pointer being passed in, sometimes
		data = FooDocumentData()
	}

	override func read(from url: URL, ofType typeName: NSString) throws {
		try! loadDocument(from: url)
	}

	override func write(to url: URL, ofType typeName: NSString, `for` saveOperation: NSSaveOperationType, originalContentsURL absoluteOriginalContentsURL: URL?) throws {
		try! saveDocument(to: url)
	}

	override func makeWindowControllers() {
		addWindowController(FooDocumentWindowController(document: self))
	}

	override class var autosavesInPlace: Bool {
		return true // enables the title bar menu, among other things
	}

	//
	// Custom members
	//

	func loadDocument(from url: URL) throws {
		data = FooDocumentData(from: url)
		if data == nil {
			throw RemObjects.Elements.System.Exception("Count not load document.")
		}
	}

	func saveDocument(to url: URL) throws {
		if let data = data {
			data.save(to: url)
		}
		throw RemObjects.Elements.System.Exception("Count not save document.")
	}

	public var data: FooDocumentData?

}

//
// data stored in the document:
//

public class FooDocumentData {

	var text: String;

	init() {
		text = "New Foo!"
	}

	init?(from url: URL) {
		if (url.path as! RemObjects.Elements.RTL.File)?.Exists() {
			text = File.ReadText(url.path)
		} else {
			return nil
		}
	}

	func save(to url: URL) {
		File.WriteText(url.path, text)
	}

}