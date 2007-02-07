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
import xpath.XPathEvaluationException;
import xpath.expression.VariableReference;
import xpath.context.Context;
import xpath.context.Environment;
import xpath.context.BaseEnvironment;
import xpath.type.XPathValue;
import xpath.type.XPathBoolean;
import xpath.type.XPathNumber;
import xpath.type.XPathString;


class TestVariableReference extends TestCase {
	
	private function testVariables () {
		var context:Context = new Context(null, null, null, new TestEnvironment());
		
		var variableReference:VariableReference = new VariableReference("a");
		var result:XPathValue = variableReference.evaluate(context);
		assertTrue(Std.is(result, XPathString));
		assertEquals("Foo", result.xPathValueApi.getString());
		
		variableReference = new VariableReference("b");
		result = variableReference.evaluate(context);
		assertTrue(Std.is(result, XPathNumber));
		assertEquals(123.0, result.xPathValueApi.getFloat());
		
		variableReference = new VariableReference("c");
		result = variableReference.evaluate(context);
		assertTrue(Std.is(result, XPathBoolean));
		assertEquals(true, result.xPathValueApi.getBool());
		
		variableReference = new VariableReference("d");
		var caught:Bool = false;
		try {
			result = variableReference.evaluate(context);
		} catch (e:XPathEvaluationException) {
			caught = true;
		}
		assertTrue(caught);
	}
	
}

private class TestEnvironment extends BaseEnvironment {
	
	public function new () {
		super();
		variables.set("a", new XPathString("Foo"));
		variables.set("b", new XPathNumber(123));
		variables.set("c", new XPathBoolean(true));
	}
	
}