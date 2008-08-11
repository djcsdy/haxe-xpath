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
import xpath.value.XPathBoolean;


class DynamicEnvironmentTest extends TestCase {
	
	function testAll () {
		var environment = new DynamicEnvironment();
		assertFalse(environment.existsFunction("foo"));
		assertFalse(environment.existsVariable("bar"));
		
		var foo = function (
			context:Context,
			parameters:Array<XPathValue>
		) :XPathValue {
			return new XPathBoolean(false);
		};
		environment.setFunction("foo", foo);
		assertTrue(environment.existsFunction("foo"));
		assertFalse(environment.existsVariable("foo"));
		assertEquals(foo, environment.getFunction("foo"));
		var result = environment.callFunction(new FakeContext(), "foo", []);
		assertTrue(Std.is(result, XPathBoolean));
		assertFalse(result.getBool());
		
		environment.removeFunction("foo");
		assertFalse(environment.existsFunction("foo"));
		
		var bar = new XPathBoolean(true);
		environment.setVariable("bar", bar);
		assertTrue(environment.existsVariable("bar"));
		assertFalse(environment.existsFunction("bar"));
		assertEquals(cast(bar, XPathValue), environment.getVariable("bar"));
		
		environment.removeVariable("bar");
		assertFalse(environment.existsVariable("bar"));
	}
	
}
