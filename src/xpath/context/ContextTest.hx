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


package xpath.context;
import Haxe.unit.TestCase;
import xpath.context.Context;
import xpath.context.Environment;
import xpath.context.DynamicEnvironment;
import xpath.xml.XPathXml;
import xpath.xml.XPathHxXml;
import xpath.value.XPathValue;
import xpath.value.XPathNumber;
import xpath.EvaluationException;


class ContextTest extends TestCase {
	
	function testAll () {
		var xml:XPathXml = XPathHxXml.wrapNode(Xml.createCData("foo"));
		var environment = new DynamicEnvironment();
		var context = new Context(xml, 42, 99, environment);
		assertEquals(xml, context.node);
		assertEquals(42, context.position);
		assertEquals(99, context.size);
		assertEquals(cast(environment, Environment), context.environment);
		
		var called = false;
		var calledParameters = null;
		environment.setFunction(
			"bar",
			function (context:Context, parameters:Array<XPathValue>) {
				called = true;
				calledParameters = parameters;
				return new XPathNumber(5);
			}
		);
		var result = context.callFunction("bar");
		assertTrue(called);
		assertEquals(0, calledParameters.length);
		assertTrue(Std.is(result, XPathNumber));
		assertEquals(5., result.getFloat());
		
		var caught = false;
		called = false;
		calledParameters = null;
		environment.removeFunction("bar");
		try {
			context.callFunction("bar");
		} catch (exception:EvaluationException) {
			caught = true;
		}
		assertTrue(caught);
		assertFalse(called);
		assertEquals(null, calledParameters);
		
		environment.setVariable("bat", new XPathNumber(3.14159));
		result = context.getVariable("bat");
		assertTrue(Std.is(result, XPathNumber));
		assertEquals(3.14159, result.getFloat());
	
		caught = false;
		environment.removeVariable("bat");
		try {
			context.getVariable("bat");
		} catch (exception:EvaluationException) {
			caught = true;
		}
		assertTrue(caught);
	}
	
}
