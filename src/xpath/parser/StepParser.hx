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
import xpath.parser.ExpressionParser;
import xpath.token.Token;
import xpath.token.EndPathToken;
import xpath.token.AxisToken;
import xpath.token.NameTestToken;
import xpath.token.TypeTestToken;
import xpath.token.PINameTestToken;
import xpath.token.StepDelimiterToken;
import xpath.token.BeginPredicateToken;
import xpath.token.EndPredicateToken;
import xpath.expression.Expression;
import xpath.expression.PathStep;
import xpath.expression.AxisStep;
import xpath.expression.NameStep;
import xpath.expression.TypeStep;
import xpath.expression.PINameStep;
import xpath.expression.FilterStep;
import xpath.expression.PredicateStep;


class StepParser implements Parser {
	
	private static var instance:StepParser;
	
	
	public static function getInstance():StepParser {
		if (instance == null) {
			instance = new StepParser();
		}
		return instance;
	}
	
	private function new () {
	}
	
	public function parse (state:ParseState) :ParseState {
		var workingState:ParseState = state.newWorkingCopy();
		
		if (Std.is(workingState.tokens[workingState.pos], StepDelimiterToken)) {
			// just ignore step delimiters; they aren't semantically important
			++workingState.pos;
			workingState = StepParser.getInstance().parse(workingState);
		} else if (Std.is(workingState.tokens[workingState.pos], AxisToken)) {
			var axis:AxisEnum = cast(state.tokens[state.pos], AxisToken).axis;
			++workingState.pos;
			workingState = StepParser.getInstance().parse(workingState);
			if (axis == Self) {
				// axis specifier self:: is effectively a no-op, so for efficiency
				// we leave it out of the parse tree
				return workingState;
			} else {
				if (workingState.result == null) {
					workingState.result = new AxisStep(axis);
				} else {
					var nextStep:PathStep = cast(workingState.result, PathStep);
					workingState.result = new AxisStep(axis, nextStep);
				}
			}
		} else if (Std.is(workingState.tokens[workingState.pos], NameTestToken)) {
			var name:String = cast(workingState.tokens[workingState.pos], NameTestToken).name;
			++workingState.pos;
			workingState = StepParser.getInstance().parse(workingState);
			if (workingState.result == null) {
				workingState.result = new NameStep(name);
			} else {
				var nextStep:PathStep = cast(workingState.result, PathStep);
				workingState.result = new NameStep(name, nextStep);
			}
		} else if (Std.is(workingState.tokens[workingState.pos], TypeTestToken)) {
			var type:TypeTestEnum = cast(workingState.tokens[workingState.pos], TypeTestToken).type;
			++workingState.pos;
			workingState = StepParser.getInstance().parse(workingState);
			if (type == Node) {
				// a type test of node() is effectively a no-op, so for efficiency
				// we leave it out of the parse tree
				return workingState;
			} else {
				if (workingState.result == null) {
					workingState.result = new TypeStep(type);
				} else {
					var nextStep:PathStep = cast(workingState.result, PathStep);
					workingState.result = new TypeStep(type, nextStep);
				}
			}
		} else if (Std.is(workingState.tokens[workingState.pos], PINameTestToken)) {
			var name:String = cast(workingState.tokens[workingState.pos], PINameTestToken).name;
			++workingState.pos;
			workingState = StepParser.getInstance().parse(workingState);
			if (workingState.result == null) {
				workingState.result = new PINameStep(name);
			} else {
				var nextStep:PathStep = cast(workingState.result, PathStep);
				workingState.result = new PINameStep(name, nextStep);
			}
		} else if (Std.is(workingState.tokens[workingState.pos], BeginPredicateToken)) {
			++workingState.pos;
			workingState = ExpressionParser.getInstance().parse(workingState);
			var predicateExpression:Expression = cast(workingState.result, Expression);
			if (!Std.is(workingState.tokens[workingState.pos], EndPredicateToken)) {
				throw new XPathInternalException();
			}
			++workingState.pos;

			workingState = StepParser.getInstance().parse(workingState);
			if (workingState.result == null) {
				workingState.result = new PredicateStep(predicateExpression);
			} else {
				var nextStep:PathStep = cast(workingState.result, PathStep);
				workingState.result = new PredicateStep(predicateExpression, nextStep);
			}
		} else {
			workingState = ExpressionParser.getInstance().parse(workingState);
			if (workingState.result != null) {
				var filterExpression:Expression = cast(workingState.result, Expression);
				workingState = StepParser.getInstance().parse(workingState);
				if (workingState.result == null) {
					workingState.result = new FilterStep(filterExpression);
				} else {
					var nextStep:PathStep = cast(workingState.result, PathStep);
					workingState.result = new FilterStep(filterExpression, nextStep);
				}
			}
		}
		
		return workingState;
	}
	
}
