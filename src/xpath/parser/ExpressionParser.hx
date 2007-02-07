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
import xpath.parser.OperandParser;
import xpath.expression.Operation;
import xpath.expression.Expression;
import xpath.token.BeginExpressionToken;
import xpath.token.OperatorToken;
import xpath.token.EndExpressionToken;


class ExpressionParser implements Parser {
	
	private static var instance:ExpressionParser;
	
	
	public static function getInstance():ExpressionParser {
		if (instance == null) {
			instance = new ExpressionParser();
		}
		return instance;
	}
	
	private function new () {
	}
	
	public function parse (state:ParseState) :ParseState {
		if (!Std.is(state.tokens[state.pos], BeginExpressionToken)) {
			// fail
			return state.newWorkingCopy();
		}
		
		var workingState:ParseState = state.newWorkingCopy();
		++workingState.pos;
		
		var output:Array<Expression> = new Array<Expression>();
		var operatorStack:Array<OperatorEnum> = new Array<OperatorEnum>();
		var precedenceStack:Array<Int> = new Array<Int>();
		
		workingState = OperandParser.getInstance().parse(workingState);
		if (workingState.result == null) {
			throw new XPathInternalException("Invalid token stream");
		}
		output.push(cast(workingState.result, Expression));
		
		while (Std.is(workingState.tokens[workingState.pos], OperatorToken)) {
			var newOperatorToken:OperatorToken = cast(workingState.tokens[workingState.pos], OperatorToken);
			++workingState.pos;
			var newOperator:OperatorEnum = newOperatorToken.operator;
			var newPrecedence:Int = newOperatorToken.getPrecedence();

			workingState = OperandParser.getInstance().parse(workingState);
			if (workingState.result == null) {
				throw new XPathInternalException("Invalid token stream");
			}
			var newOperand:Expression = cast(workingState.result, Expression);
			
			while (precedenceStack.length > 0 && newPrecedence<=precedenceStack[precedenceStack.length-1]) {
				precedenceStack.pop();
				var rightOperand:Expression = output.pop();
				var leftOperand:Expression = output.pop();
				var operator:OperatorEnum = operatorStack.pop();
				
				output.push(new Operation(leftOperand, operator, rightOperand));
			}
			
			output.push(newOperand);
			operatorStack.push(newOperator);
			precedenceStack.push(newPrecedence);
		}
		precedenceStack = null;
		
		while (operatorStack.length > 0) {
			var rightOperand:Expression = output.pop();
			var leftOperand:Expression = output.pop();
			var operator:OperatorEnum = operatorStack.pop();
			
			output.push(new Operation(leftOperand, operator, rightOperand));
		}
		operatorStack = null;
		
		if (output.length != 1) {
			throw new XPathInternalException();
		}
		
		if (!Std.is(workingState.tokens[workingState.pos], EndExpressionToken)) {
			throw new XPathInternalException("Invalid token stream");
		}

		workingState.result = output[0];
		++workingState.pos;
		return workingState;
	}
	
}
