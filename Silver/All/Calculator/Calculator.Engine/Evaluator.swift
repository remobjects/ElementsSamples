import Sugar
import Sugar.Collections

enum EvaluatorTokenType: Int32 {
	case EOF
	case Number
	case Op_Add
	case Op_Sub
	case Op_Mul
	case Op_Div
	case Error
}

class EvaluatorError: Exception {
}

class EvaluatorToken {
	public init(token: EvaluatorTokenType, value: String, offset: Integer) {
		self.Token = token
		self.Value = value
		self.Offset = offset
	}

	public let Token: EvaluatorTokenType
	public let Value: String
	public let Offset: Integer
}

public class Evaluator {
	public init() {
	}
	private static let EOF = EvaluatorToken(token: EvaluatorTokenType.EOF, value: "", offset: 0)

	private var Tokens: List<EvaluatorToken>!
	private var Index: Int = 0

	// returns the current token, or EOF if at the end
	private var Current: EvaluatorToken { 
		if Tokens != nil && Index < Tokens.Count {
			return Tokens[Index] 
		}
		return EOF
	}

	// Evaluates a string expression like (1 + 2 * 4.5) and return the evaluated value
	public func Evaluate(input: String) -> Double {
		Tokens = Tokenize(input)
		Index = 0

		return ParseAdditionExpression()
	}

	// Parses + and - expressions, this is split from * and / so that 
	// + and - have a lower prescendence than * and /
	private func ParseAdditionExpression() -> Double {
		var l = ParseMultiplicationExpression()
		while Current.Token == EvaluatorTokenType.Op_Sub || Current.Token == EvaluatorTokenType.Op_Add {
			let sub = Current.Token == EvaluatorTokenType.Op_Sub
			Index++
			let r = ParseMultiplicationExpression()
			if (sub) {
				l = l - r
			} else {
				l = l + r
			}
		}
		return l
	}

	// Parse * and / 
	private func ParseMultiplicationExpression() -> Double {
		var l = ParseValueExpression()
		while Current.Token == EvaluatorTokenType.Op_Mul || Current.Token == EvaluatorTokenType.Op_Div {
			let mul = Current.Token == EvaluatorTokenType.Op_Mul
			Index++
			let r = ParseValueExpression()
			if (mul) {
				l = l * r
			} else {
				l = l / r
			}
		}
		return l
	}

	private func ParseValueExpression() -> Double {
		switch (Current.Token)
		{
			case EvaluatorTokenType.Op_Add: // Process +15 as unary
				Index++
				return ParseValueExpression()
			case EvaluatorTokenType.Op_Sub: // Process -15 as unary
				Index++
				return -ParseValueExpression()
			case EvaluatorTokenType.Number:
				var res = Current.Value
				Index++
				return Convert.ToDoubleInvariant(res)
			case EvaluatorTokenType.EOF:
				__throw EvaluatorError("Unexected end of expression")
			default:
				__throw EvaluatorError("Unknown value at offset " + Current.Offset)
			
		}
	}
	// Splits the string into parts; skipping whitespace
	private static func Tokenize(input: String) -> List<EvaluatorToken> {
		var res = List<EvaluatorToken>()
		var input = input;
		// for parsing convenience so look ahead won't throw exceptions.
		input = input + "\0\0" 
		
		var i = 0
		while (i < input.Length) {
			var c: Int = i
			switch (input[i]){
				case "\0":
					i = input.Length
				case "0", "1","2","3","4","5","6","7","8","9",".":
					c = i + 1
					var gotDot = input[i] == "."
					while true {
						var ch = input[c]
						if ch == "0" || ch ==  "1" || ch == "2" || ch == "3" || ch == "4" || ch == "5" || ch == "6" || ch == "7" || 
						ch == "8" || ch == "9" || (!gotDot && ch == ".") {
							c++
							if (ch == ".") {
								gotDot = true
							}
						} else {
							break
						}
					}
					res.Add(EvaluatorToken(token: EvaluatorTokenType.Number, value: input.Substring(i, c-i), offset: i))
					i = c
				case "+": 
					res.Add(EvaluatorToken(token: EvaluatorTokenType.Op_Add, value: "+", offset: i))
					i++
				case "-": 
					res.Add(EvaluatorToken(token: EvaluatorTokenType.Op_Sub, value: "-", offset: i))
					i++
				case "*": 
					res.Add(EvaluatorToken(token: EvaluatorTokenType.Op_Mul, value: "*", offset: i))
					i++
				case "/": 
					res.Add(EvaluatorToken(token: EvaluatorTokenType.Op_Div, value: "/", offset: i))
					i++
				case " ", "\t", "\r", "\n": 
					i++
				default: 
					res.Add(EvaluatorToken(token: EvaluatorTokenType.Error, value: input[i], offset: i))
					i++ 
			}
		}
		return res
	}
}
