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


package xpath.unit.parser;
import haxe.unit.TestCase;
import xpath.parser.ExpressionParser;
import xpath.parser.ParseState;
import xpath.expression.Literal;
import xpath.expression.Number;
import xpath.expression.Operation;
import xpath.token.Token;
import xpath.token.BeginExpressionToken;
import xpath.token.EndExpressionToken;
import xpath.token.LiteralToken;
import xpath.token.NumberToken;
import xpath.token.OperatorToken;


class TestExpressionParser extends TestCase {
	
	private function testSimpleLiteral () {
		var state:ParseState = new ParseState([
			cast(new BeginExpressionToken(), Token), new LiteralToken("test123"),
			new EndExpressionToken()
		]);
		state = ExpressionParser.getInstance().parse(state);
		
		assertEquals(3, state.pos);
		assertTrue(Std.is(state.result, Literal));
		assertEquals("test123", Reflect.field(state.result, "value"));
	}
	
	private function testSimpleNumber () {
		var state:ParseState = new ParseState([
			cast(new BeginExpressionToken(), Token), new NumberToken(123.45),
			new EndExpressionToken()
		]);
		state = ExpressionParser.getInstance().parse(state);
		
		assertEquals(3, state.pos);
		assertTrue(Std.is(state.result, Number));
		assertEquals(123.45, Reflect.field(state.result, "value"));
	}
	
	private function testSimpleOperation () {
		var state:ParseState = new ParseState([
			cast(new BeginExpressionToken(), Token), new NumberToken(123.45),
			new OperatorToken(Plus), new NumberToken(67.8), new EndExpressionToken()
		]);
		state = ExpressionParser.getInstance().parse(state);
		
		assertEquals(5, state.pos);
		assertTrue(Std.is(state.result, Operation));
		var operation:Operation = cast(state.result, Operation);
		assertEquals(Plus, Reflect.field(operation, "operator"));
		assertTrue(Std.is(Reflect.field(operation, "leftOperand"), Number));
		var leftOperand:Number = cast(Reflect.field(operation, "leftOperand"), Number);
		assertEquals(123.45, Reflect.field(leftOperand, "value"));
		assertTrue(Std.is(Reflect.field(operation, "rightOperand"), Number));
		var rightOperand:Number = cast(Reflect.field(operation, "rightOperand"), Number);
		assertEquals(67.8, Reflect.field(rightOperand, "value"));
	}
	
	private function testPrecedence1 () {
		var state:ParseState = new ParseState([
			cast(new BeginExpressionToken(), Token), new NumberToken(1),
			new OperatorToken(Plus), new NumberToken(2), new OperatorToken(Multiply),
			new NumberToken(3), new EndExpressionToken()
		]);
		state = ExpressionParser.getInstance().parse(state);
		
		assertEquals(7, state.pos);
		assertTrue(Std.is(state.result, Operation));
		var operation:Operation = cast(state.result, Operation);
		assertEquals(Plus, Reflect.field(operation, "operator"));
		assertTrue(Std.is(Reflect.field(operation, "leftOperand"), Number));
		var leftOperand:Number = cast(Reflect.field(operation, "leftOperand"), Number);
		assertEquals(1.0, Reflect.field(leftOperand, "value"));
		assertTrue(Std.is(Reflect.field(operation, "rightOperand"), Operation));
		operation = cast(Reflect.field(operation, "rightOperand"), Operation);
		assertEquals(Multiply, Reflect.field(operation, "operator"));
		assertTrue(Std.is(Reflect.field(operation, "leftOperand"), Number));
		leftOperand = cast(Reflect.field(operation, "leftOperand"), Number);
		assertEquals(2, Reflect.field(leftOperand, "value"));
		assertTrue(Std.is(Reflect.field(operation, "rightOperand"), Number));
		var rightOperand:Number = cast(Reflect.field(operation, "rightOperand"), Number);
		assertEquals(3, Reflect.field(rightOperand, "value"));
	}
	
	private function testPrecedence2 () {
		var state:ParseState = new ParseState([
			cast(new BeginExpressionToken(), Token), new NumberToken(1),
			new OperatorToken(Plus), new NumberToken(2), new OperatorToken(Multiply),
			new NumberToken(3), new OperatorToken(Equal), new NumberToken(7), new EndExpressionToken()
		]);
		state = ExpressionParser.getInstance().parse(state);
		
		assertEquals(9, state.pos);
		assertTrue(Std.is(state.result, Operation));
		var operation:Operation = cast(state.result, Operation);
		assertEquals(Equal, Reflect.field(operation, "operator"));
		assertTrue(Std.is(Reflect.field(operation, "rightOperand"), Number));
		var rightOperand:Number = cast(Reflect.field(operation, "rightOperand"), Number);
		assertEquals(7, Reflect.field(rightOperand, "value"));
		assertTrue(Std.is(Reflect.field(operation, "leftOperand"), Operation));
		operation = cast(Reflect.field(operation, "leftOperand"), Operation);
		assertEquals(Plus, Reflect.field(operation, "operator"));
		assertTrue(Std.is(Reflect.field(operation, "leftOperand"), Number));
		var leftOperand:Number = cast(Reflect.field(operation, "leftOperand"), Number);
		assertEquals(1.0, Reflect.field(leftOperand, "value"));
		assertTrue(Std.is(Reflect.field(operation, "rightOperand"), Operation));
		operation = cast(Reflect.field(operation, "rightOperand"), Operation);
		assertEquals(Multiply, Reflect.field(operation, "operator"));
		assertTrue(Std.is(Reflect.field(operation, "leftOperand"), Number));
		leftOperand = cast(Reflect.field(operation, "leftOperand"), Number);
		assertEquals(2, Reflect.field(leftOperand, "value"));
		assertTrue(Std.is(Reflect.field(operation, "rightOperand"), Number));
		var rightOperand:Number = cast(Reflect.field(operation, "rightOperand"), Number);
		assertEquals(3, Reflect.field(rightOperand, "value"));
	}
	
}