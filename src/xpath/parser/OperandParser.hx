/* haXe XPath by Daniel J. Cassidy <mail@danielcassidy.me.uk>
 * Dedicated to the Public Domain
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS AND ANY EXPRESS 
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


package xpath.parser;
import xpath.parser.Parser;
import xpath.XPathInternalException;
import xpath.parser.ParseState;
import xpath.parser.PathParser;
import xpath.parser.GroupParser;
import xpath.parser.FunctionCallParser;
import xpath.expression.Expression;
import xpath.expression.Negation;
import xpath.expression.Literal;
import xpath.expression.Number;
import xpath.expression.VariableReference;
import xpath.token.Token;
import xpath.token.NegationOperatorToken;
import xpath.token.LiteralToken;
import xpath.token.NumberToken;
import xpath.token.VariableReferenceToken;


class OperandParser implements Parser {
	
	private static var instance:OperandParser;
	
	
	public static function getInstance():OperandParser {
		if (instance == null) {
			instance = new OperandParser();
		}
		return instance;
	}
	
	private function new () {
	}
	
	public function parse (state:ParseState) :ParseState {
		var resultState:ParseState = state.newWorkingCopy();
		
		var token:Token = state.tokens[state.pos];
		if (Std.is(token, NegationOperatorToken)) {
			++resultState.pos;
			
			resultState = parse(resultState);
			resultState.result = new Negation(cast(resultState.result, Expression));
			
			return resultState;
		} else if (Std.is(token, LiteralToken)) {
			resultState.result = new Literal(cast(token, LiteralToken).value);
			++resultState.pos;
		} else if (Std.is(token, NumberToken)) {
			resultState.result = new Number(cast(token, NumberToken).value);
			++resultState.pos;
		} else if (Std.is(token, VariableReferenceToken)) {
			resultState.result = new VariableReference(cast(token, VariableReferenceToken).name);
			++resultState.pos;
		} else {
			var workingState:ParseState = PathParser.getInstance().parse(state);
			if (workingState.result == null) {
				workingState = GroupParser.getInstance().parse(state);
			}
			if (workingState.result == null) {
				workingState = FunctionCallParser.getInstance().parse(state);
			}
			
			if (workingState.result != null) {
				resultState = workingState;
			}
		}
		
		return resultState;
	}
	
}
