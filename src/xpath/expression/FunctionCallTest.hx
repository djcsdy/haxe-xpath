/* Haxe XPath by Daniel J. Cassidy <mail@danielcassidy.me.uk>
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


package xpath.expression;
import Haxe.unit.TestCase;
import xpath.context.Context;
import xpath.context.FakeContext;
import xpath.context.DynamicEnvironment;
import xpath.value.XPathValue;
import xpath.value.XPathString;
import xpath.value.XPathNumber;


class FunctionCallTest extends TestCase {
	
	var context :FakeContext;
	
	
	public function new () {
		super();
		
		var environment = new DynamicEnvironment();
		
		environment.setFunction("simple", function (
			context:Context,
			arguments:Array<XPathValue>
		) {
			return new XPathString("simple");
		});
		
		environment.setFunction("string", function (
			context:Context,
			arguments:Array<XPathValue>
		) {
			return arguments[0].getXPathString();
		});
		
		environment.setFunction("sum", function (
			context:Context,
			arguments:Array<XPathValue>
		) {
			return new XPathNumber(
				arguments[0].getFloat() +
				arguments[1].getFloat()
			);
		});
		
		context = new FakeContext(environment);
	}
	
	function testSimple () {
		var functionCall = new FunctionCall("simple", []);
		var result = functionCall.evaluate(context);
		assertEquals("simple", result.getString());
	}
	
	function test1Arg () {
		for (arg in [
			cast(new Literal("abcdef"), Expression),
			new Literal(""),
			new Literal("foo"),
			new Number(24),
			new Number(-511),
			new FakeBooleanExpression(true),
			new FakeBooleanExpression(false)
		]) {
			var functionCall = new FunctionCall("string", [arg]);
			var result = functionCall.evaluate(context);
			assertEquals(arg.evaluate(context).getString(), result.getString());
		}
	}
	
	function test2Arg () {
		for (arg1Value in [0.0, 1.5, 5, 10, -50, 200]) {
			var arg1 = new Number(arg1Value);
			
			for (arg2Value in [0, 20, -217.823, 4000]) {
				var arg2 = new Number(arg2Value);
				var functionCall = new FunctionCall("sum", [
					cast(arg1, Expression), arg2
				]);
				var result =  functionCall.evaluate(context);
				assertEquals(arg1Value+arg2Value, result.getFloat());
			}
		}
	}
	
}
