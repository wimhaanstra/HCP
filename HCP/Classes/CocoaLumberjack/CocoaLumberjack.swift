//  Created by Ullrich SchÃ¤fer on 16/08/14.


// Bitmasks are a bit tricky in swift
// See http://natecook.com/blog/2014/07/swift-options-bitmask-generator/

//enum LogFlag: Int32 {
//    case Error   = 0b1
//    case Warn    = 0b10
//    case Info    = 0b100
//    case Debug   = 0b1000
//    case Verbose = 0b10000
//}

struct LogFlag : RawOptionSetType {
	private var value: Int32 = 0
	init(_ value: Int32) { self.value = value }
	var boolValue: Bool { return self.value != 0 }
	func toRaw() -> Int32 { return self.value }
	
	static var allZeros:LogFlag { return self(0) }
	static func fromRaw(raw: Int32) -> LogFlag? { return self(raw) }
	static func fromMask(raw: Int32) -> LogFlag { return self(raw) }
	static func convertFromNilLiteral() -> LogFlag { return self(0) }
	
	static var Error:   LogFlag { return self(1 << 0) }
	static var Warn:    LogFlag { return self(1 << 1) }
	static var Info:    LogFlag { return self(1 << 2) }
	static var Debug:   LogFlag { return self(1 << 3) }
	static var Verbose: LogFlag { return self(1 << 4) }
}
func == (lhs: LogFlag, rhs: LogFlag) -> Bool { return lhs.value == rhs.value }



//enum LogLevel: Int32 {
//    case Off     = 0b0
//    case Error   = 0b1
//    case Warn    = 0b11
//    case Info    = 0b111
//    case Debug   = 0b1111
//    case Verbose = 0b11111
//    case All     = 0bFFFFFFFF // 1111....11111 (LOG_LEVEL_VERBOSE plus any other flags)
//}

struct LogLevel : RawOptionSetType {
	private var value: Int32 = 0
	init(_ value: Int32) { self.value = value }
	var boolValue: Bool { return self.value != 0 }
	func toRaw() -> Int32 { return self.value }
	static func fromRaw(raw: Int32) -> LogLevel? { return self(raw) }
	static func fromMask(raw: Int32) -> LogLevel { return self(raw) }
	static func convertFromNilLiteral() -> LogLevel { return self(0) }
	
	static var allZeros: LogLevel { return self(0b11111111) }
	static var Off:     LogLevel { return self(0b0) }
	static var Error:   LogLevel { return self(0b1) }
	static var Warn:    LogLevel { return self(0b11) }
	static var Info:    LogLevel { return self(0b111) }
	static var Debug:   LogLevel { return self(0b1111) }
	static var Verbose: LogLevel { return self(0b11111) }
	static var All:     LogLevel { return self(0b11111111) }
}
func == (lhs: LogLevel, rhs: LogLevel) -> Bool { return lhs.value == rhs.value }



// what's a better way than poluting the global scope?
var __logLevel: LogLevel?
var __logAsync: Bool?


// Use those class properties insted of `#define LOG_LEVEL_DEF` and `LOG_ASYNC_ENABLED`
extension DDLog {
	class var logLevel: LogLevel {
		get {
		return __logLevel ?? LogLevel.Error
		}
		set(logLevel) {
			__logLevel = logLevel
		}
	}
	
	class var logAsync: Bool {
		get {
		return (self.logLevel != LogLevel.Error) && (__logAsync ?? true)
		}
		set(logAsync) {
			__logAsync = logAsync
		}
	}
	
	class func logError (message: String, function: String = __FUNCTION__, file: String = __FILE__, line: Int32 = __LINE__) {
		log(.Error, message: message, function: function, file: file, line: line)
	}
	
	class func logWarn  (message: String, function: String = __FUNCTION__, file: String = __FILE__, line: Int32 = __LINE__) { log(.Warn,  message: message, function: function, file: file, line: line) }
	class func logInfo  (message: String, function: String = __FUNCTION__, file: String = __FILE__, line: Int32 = __LINE__) { log(.Info,  message: message, function: function, file: file, line: line) }
	class func logDebug (message: String, function: String = __FUNCTION__, file: String = __FILE__, line: Int32 = __LINE__) { log(.Debug, message: message, function: function, file: file, line: line) }
	
	private class func log (
		flag: LogFlag,
		message: String,
		// No need to pass those in. the defaults will do just fine
		function: String = __FUNCTION__,
		file: String = __FILE__,
		line: Int32 = __LINE__
		)
	{
		let level:LogLevel = DDLog.logLevel
		let async:Bool = (level != LogLevel.Error) && DDLog.logAsync
		
		if flag.toRaw() & level.toRaw() != 0 {
			DDLog.log(
				async,
				message: DDLogMessage(logMsg: message,
					level: level.toRaw(),
					flag: flag.toRaw(),
					context: 0,
					file: file,
					function: function,
					line: line,
					tag: nil,
					options: 0))
		}
	}
}

// Shorthands, what you'd expect
/* //Not possible due to http://openradar.appspot.com/radar?id=5773154781757440
let logError = DDLog.logError
let logWarn  = DDLog.logWarn
let logInfo  = DDLog.logInfo
let logDebug = DDLog.logDebug
*/
func logError (message: String, function: String = __FUNCTION__, file: String = __FILE__, line: Int32 = __LINE__) { DDLog.logError(message, function: function, file: file, line: line) }
func logWarn  (message: String, function: String = __FUNCTION__, file: String = __FILE__, line: Int32 = __LINE__) { DDLog.logWarn(message, function: function, file: file, line: line) }
func logInfo  (message: String, function: String = __FUNCTION__, file: String = __FILE__, line: Int32 = __LINE__) { DDLog.logInfo(message, function: function, file: file, line: line) }
func logDebug (message: String, function: String = __FUNCTION__, file: String = __FILE__, line: Int32 = __LINE__) { DDLog.logDebug(message, function: function, file: file, line: line) }