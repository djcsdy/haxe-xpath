/* haXe XPath by Daniel J. Cassidy <mail@danielcassidy.me.uk>
 * Dedicated to the Public Domain
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS 
 * OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 * GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. */


package xpath.tokenizer.token;
import xpath.tokenizer.token.TokenTokenizer;
import xpath.tokenizer.Tokenizer;
import xpath.tokenizer.TokenizeState;
import xpath.token.Token;
import xpath.token.OperatorToken;


class OperatorTokenizer extends TokenTokenizer {
	
	private static var instance:OperatorTokenizer;
	
	private var operatorSymbols:Array<String>;
	
	private var operatorSymbolToOperatorEnum:Hash<OperatorEnum>;
	
	
	public static function getInstance () :OperatorTokenizer {
		if (instance == null) instance = new OperatorTokenizer();
		return instance;
	}
	
	private function new () {
		operatorSymbolToOperatorEnum = new Hash<OperatorEnum>();
		operatorSymbolToOperatorEnum.set("and", And);
		operatorSymbolToOperatorEnum.set("mod", Modulo);
		operatorSymbolToOperatorEnum.set("div", Divide);
		operatorSymbolToOperatorEnum.set("or", Or);
		operatorSymbolToOperatorEnum.set("!=", NotEqual);
		operatorSymbolToOperatorEnum.set("<=", LessThanOrEqual);
		operatorSymbolToOperatorEnum.set(">=", GreaterThanOrEqual);
		operatorSymbolToOperatorEnum.set("=", Equal);
		operatorSymbolToOperatorEnum.set("|", Union);
		operatorSymbolToOperatorEnum.set("+", Plus);
		operatorSymbolToOperatorEnum.set("-", Minus);
		operatorSymbolToOperatorEnum.set("<", LessThan);
		operatorSymbolToOperatorEnum.set(">", GreaterThan);
		operatorSymbolToOperatorEnum.set("*", Multiply);
		
		operatorSymbols = new Array<String>();
		for (operatorSymbol in operatorSymbolToOperatorEnum.keys()) {
			operatorSymbols.push(operatorSymbol);
		}
		
		// sort symbols by length, longest first
		operatorSymbols.sort(function (x:String, y:String) {
			return y.length - x.length;
		});
	}

	override public function tokenize (state:TokenizeState) :TokenizeState {
		var resultState:TokenizeState = state.newWorkingCopy();
		var pos:Int = resultState.pos;

		// check for operator symbol
		for (operatorSymbol in operatorSymbols) {
			if (resultState.xpathStr.substr(pos, operatorSymbol.length) == operatorSymbol) {
				// succeed
				var operatorEnum:OperatorEnum = operatorSymbolToOperatorEnum.get(operatorSymbol);
				resultState.result = [cast(new OperatorToken(operatorEnum), Token)];
				resultState.pos = skipWhitespace(resultState.xpathStr, pos + operatorSymbol.length);
				return resultState;
			}
		}
		
		// fail
		return resultState;
	}
	
}