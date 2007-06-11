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


package xpath.parser;
import xpath.parser.Parser;
import xpath.XPathError;
import xpath.parser.ParseState;
import xpath.token.BeginFunctionCallToken;
import xpath.token.ArgumentDelimiterToken;
import xpath.token.EndFunctionCallToken;
import xpath.expression.Expression;
import xpath.expression.FunctionCall;


class FunctionCallParser implements Parser {
	
	private static var instance:FunctionCallParser;
	
	
	public static function getInstance():FunctionCallParser {
		if (instance == null) {
			instance = new FunctionCallParser();
		}
		return instance;
	}
	
	private function new () {
	}
	
	public function parse (state:ParseState) :ParseState {
		if (!Std.is(state.tokens[state.pos], BeginFunctionCallToken)) {
			// fail
			return state.newWorkingCopy();
		}
		
		var workingState:ParseState = state.newWorkingCopy();
		++workingState.pos;

		var beginFunctionCallToken:BeginFunctionCallToken = cast(state.tokens[state.pos], BeginFunctionCallToken);
		var name:String = beginFunctionCallToken.name;
		
		var arguments:Array<Expression> = new Array<Expression>();
		workingState = ExpressionParser.getInstance().parse(workingState);
		if (workingState.result != null) {
			arguments.push(cast(workingState.result, Expression));
			while (Std.is(workingState.tokens[workingState.pos], ArgumentDelimiterToken)) {
				++workingState.pos;
				workingState = ExpressionParser.getInstance().parse(workingState);
				var argument:Expression = cast(workingState.result, Expression);
				arguments.push(argument);
			}
		}
		
		if (!Std.is(workingState.tokens[workingState.pos], EndFunctionCallToken)) {
			throw new XPathError("Invalid token stream");
		}
		++workingState.pos;
		
		workingState.result = new FunctionCall(name, arguments);
		return workingState;
	}
	
}
