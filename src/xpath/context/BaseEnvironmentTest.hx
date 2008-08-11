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


package xpath.context;
import haxe.unit.TestCase;
import xpath.value.XPathValue;
import xpath.value.XPathNumber;
import xpath.EvaluationException;


class BaseEnvironmentTest extends TestCase {
	
	function testExists () {
		var environment = new FakeBaseEnvironment();
		assertFalse(environment.existsFunction("bananas"));
		assertFalse(environment.existsVariable("bananas"));
		assertTrue(environment.existsFunction("apples"));
		assertFalse(environment.existsVariable("apples"));
		assertFalse(environment.existsFunction("pears"));
		assertFalse(environment.existsVariable("pears"));
		assertFalse(environment.existsFunction("cherries"));
		assertTrue(environment.existsVariable("cherries"));
		assertFalse(environment.existsFunction("grapes"));
		assertFalse(environment.existsVariable("grapes"));
	}
	
	function testCallFunction () {
		var environment = new FakeBaseEnvironment();
		var context = new FakeContext(environment);
		
		var parameters = new Array<XPathValue>();
		var result = environment.callFunction(
			context, "apples", parameters
		);
		assertEquals(1, environment.applesCount);
		assertEquals(parameters, environment.applesParameters);
		assertTrue(Std.is(result, XPathNumber));
		assertEquals(3.14159, result.getFloat());
		
		var caught = false;
		try {
			environment.callFunction(context, "bananas", parameters);
		} catch (exception:EvaluationException) {
			caught = true;
		}
		assertTrue(caught);
		
		caught = false;
		try {
			environment.callFunction(context, "pears", parameters);
		} catch (exception:EvaluationException) {
			caught = true;
		}
		assertTrue(caught);
	}
	
	function testGetVariable () {
		var environment = new FakeBaseEnvironment();
		var context = new FakeContext(environment);
		
		var result = environment.getVariable("cherries");
		assertTrue(Std.is(result, XPathNumber));
		assertEquals(42., result.getFloat());
		
		var caught = false;
		try {
			environment.getVariable("bananas");
		} catch (exception:EvaluationException) {
			caught = true;
		}
		assertTrue(caught);
		
		caught = false;
		try {
			environment.getVariable("grapes");
		} catch (exception:EvaluationException) {
			caught = true;
		}
		assertTrue(caught);
	}
	
}

private class FakeBaseEnvironment extends BaseEnvironment {
	
	public var applesCount :Int;
	public var applesParameters :Array<XPathValue>;
	
	
	public function new () {
		super();
		applesCount = 0;
		
		var me = this;
		functions.set("apples", function (
			context:Context, parameters:Array<XPathValue>
		) :XPathValue {
			me.applesCount++;
			me.applesParameters = parameters;
			return new XPathNumber(3.14159);
		});
		functions.set("pears", null);
		
		variables.set("cherries", new XPathNumber(42));
		variables.set("grapes", null);
	}
	
}
