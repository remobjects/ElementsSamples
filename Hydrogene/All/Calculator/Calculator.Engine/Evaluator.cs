using Sugar;
using Sugar.Collections;

namespace Calculator.Engine
{
	enum EvaluatorTokenType: int 
	{
		EOF, Number, Op_Add, Op_Sub, Op_Mul, Op_Div, Error
	}

	class EvaluatorError: Exception 
	{
	}

	class EvaluatorToken 
	{
		public EvaluatorToken(EvaluatorTokenType token, string value, int offset) 
		{
			this.Token = token;
			this.Value = value;
			this.Offset = offset;
		}

		public EvaluatorTokenType Token; 
		public string Value;
		public int Offset;
	}

	public class Evaluator
	{
		private static EvaluatorToken EOF = new EvaluatorToken(token: EvaluatorTokenType.EOF, value: "", offset: 0);

		private List<EvaluatorToken> Tokens;
		private int Index = 0;

		// returns the current token, or EOF if at the end
		private EvaluatorToken Current
		{ 
			get 
			{
				if (Tokens != null && Index < Tokens.Count)
					return Tokens[Index]; 
				return EOF;
			}
		}

		// Evaluates a string expression like (1 + 2 * 4.5) and return the evaluated value
		public double Evaluate(string input)
		{
			Tokens = Tokenize(input);
			Index = 0;

			return ParseAdditionExpression();
		}

		// Parses + and - expressions, this is split from * and / so that 
		// + and - have a lower prescendence than * and /
		private double ParseAdditionExpression()
		{
			var l = ParseMultiplicationExpression();
			while (Current.Token == EvaluatorTokenType.Op_Sub || Current.Token == EvaluatorTokenType.Op_Add)
			{
				var sub = Current.Token == EvaluatorTokenType.Op_Sub;
				Index++;
				var r = ParseMultiplicationExpression();
				if (sub) 
					l = l - r;
				else
					l = l + r;
			}
			return l;
		}

		// Parse * and / 
		private double ParseMultiplicationExpression()
		{			
			var l = ParseValueExpression();
			while (Current.Token == EvaluatorTokenType.Op_Mul || Current.Token == EvaluatorTokenType.Op_Div)
			{
				var mul = Current.Token == EvaluatorTokenType.Op_Mul;
				Index++;
				var r = ParseValueExpression();
				if (mul) 
					l = l * r;
				else
					l = l / r;
			}
			return l;
		}

		private double ParseValueExpression() 
		{
			switch (Current.Token)
			{
				case EvaluatorTokenType.Op_Add: // Process +15 as unary
					Index++;
					return ParseValueExpression();
				case EvaluatorTokenType.Op_Sub: // Process -15 as unary
					Index++;
					return -ParseValueExpression();
				case EvaluatorTokenType.Number:
					var res = Current.Value;
					Index++;
					return Convert.ToDoubleInvariant(res);
				case EvaluatorTokenType.EOF:
					throw new EvaluatorError("Unexected end of expression");
				default:
					throw new EvaluatorError("Unknown value at offset " + Current.Offset);
			}
		}

		// Splits the string into parts; skipping whitespace
		private static List<EvaluatorToken> Tokenize(String input) 
		{		
			var res = new List<EvaluatorToken>();
		
			// for parsing convenience so look ahead won't throw exceptions.
			input = input + "\0\0";
		
			var i = 0;
			while (i < input.Length) {
				int c = i;
				switch (input[i])
				{
					case '\0':
						i = input.Length;
						break;
					case '0': case '1': case '2': case '3': case '4': case '5': 
					case '6': case '7': case '8': case '9': case '.':
						c = i + 1;
						var gotDot = input[i] == '.';
						while (true)
						{
							var ch = input[c];
							if ((ch == '0') || (ch ==  '1') || (ch == '2') || (ch == '3') || (ch == '4') || (ch == '5') || 
							   (ch == '6') || (ch == '7') || (ch == '8') || (ch == '9') || (!gotDot && ch == '.')) 
							{
								c++;
								if (ch == '.')
									gotDot = true;
							}
							else 
								break;
						}
						res.Add(new EvaluatorToken(token: EvaluatorTokenType.Number, value: input.Substring(i, c-i), offset: i));
						i = c;
						break;
					case '+': 
						res.Add(new EvaluatorToken(token: EvaluatorTokenType.Op_Add, value: "+", offset: i));
						i++;
						break;
					case '-': 
						res.Add(new EvaluatorToken(token: EvaluatorTokenType.Op_Sub, value: "-", offset: i));
						i++;
						break;
					case '*': 
						res.Add(new EvaluatorToken(token: EvaluatorTokenType.Op_Mul, value: "*", offset: i));
						i++;
						break;
					case '/': 
						res.Add(new EvaluatorToken(token: EvaluatorTokenType.Op_Div, value: "/", offset: i));
						i++;
						break;
					case ' ': case '\t': case '\r': case '\n':
						i++;
						break;
					default: 
						res.Add(new EvaluatorToken(token: EvaluatorTokenType.Error, value: "" + input[i], offset: i));
						i++;
						break;
				}
			}
			return res;
		}
	}
}
