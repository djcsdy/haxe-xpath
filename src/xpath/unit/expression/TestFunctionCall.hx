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


package xpath.unit.expression;
import haxe.unit.TestCase;
import xpath.expression.Expression;
import xpath.expression.FunctionCall;
import xpath.context.Context;
import xpath.context.Environment;
import xpath.context.BaseEnvironment;
import xpath.type.XPathValue;
import xpath.type.XPathBoolean;
import xpath.type.XPathNumber;
import xpath.type.XPathString;


class TestFunctionCall extends TestCase {
	
	private var context:Context;
	
	
	public function new () {
		super();
		context = new Context(null, null, null, new TestEnvironment());
	}
	
	private function testSimple () {
		var functionCall:FunctionCall = new FunctionCall("simple", []);
		var result:XPathValue = functionCall.evaluate(context);
		
		assertEquals("simple", result.xPathValueApi.getString());
	}
	
	private function test1arg () {
		for (arg in [
			cast(new TestStringExpression("abcdef"), Expression), new TestStringExpression(""),
			new TestStringExpression("foo"), new TestNumericExpression(24),
			new TestNumericExpression(-511), new TestTrueExpression(), new TestFalseExpression() 
		]) {
			var functionCall:FunctionCall = new FunctionCall("string", [arg]);
			var result:XPathValue = functionCall.evaluate(context);
			
			assertEquals(arg.expressionApi.evaluate(context).xPathValueApi.getString(), result.xPathValueApi.getString());
		}
	}
	
	private function test2arg () {
		for (arg1Value in [0.0, 1.5, 5, 10, -50, 200]) {
			var arg1:Expression = new TestNumericExpression(arg1Value);
			
			for (arg2Value in [0, 20, -217.823, 4000]) {
				var arg2:Expression = new TestNumericExpression(arg2Value);
				var functionCall:FunctionCall = new FunctionCall("sum", [arg1, arg2]);
				var result:XPathValue = functionCall.evaluate(context);
				
				assertEquals(arg1Value+arg2Value, result.xPathValueApi.getFloat());
			}
		}
	}
	
}

private class TestEnvironment extends BaseEnvironment {
	
	public function new () {
		super();
		functions.set("simple", simple);
		functions.set("string", string);
		functions.set("sum", sum);
	}
	
	private function simple (context:Context, arguments:Array<XPathValue>) :XPathValue {
		return new XPathString("simple");
	}
	
	private function string (context:Context, arguments:Array<XPathValue>) :XPathValue {
		return arguments[0].getXPathString();
	}
	
	private function sum (context:Context, arguments:Array<XPathValue>) :XPathValue {
		return new XPathNumber(arguments[0].xPathValueApi.getFloat() + arguments[1].xPathValueApi.getFloat());
	}
	
}

private class TestStringExpression extends Expression {
	
	private var value:String;
	
	
	public function new (value:String) {
		super(this);
		this.value = value;
	}
	
	public function evaluate (context:Context) :XPathValue {
		return new XPathString(value);
	}
	
}

private class TestNumericExpression extends Expression {
	
 	private var value:Float;
 	
 	
 	public function new (value:Float) {
 		super(this);
 		this.value = value;
 	}
 	
 	public function evaluate (context:Context) :XPathValue {
 		return new XPathNumber(value);
 	}
 	
}

private class TestTrueExpression extends Expression {
	
	public function new () {
		super(this);
	}
	
	public function evaluate (context:Context) :XPathValue {
		return new XPathBoolean(true);
	}
	
}

private class TestFalseExpression extends Expression {
	
	public function new () {
		super(this);
	}
	
	public function evaluate (context:Context) :XPathValue {
		return new XPathBoolean(false);
	}
	
}