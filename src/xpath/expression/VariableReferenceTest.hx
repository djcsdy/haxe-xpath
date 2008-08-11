/* haXe XPath
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
import haxe.unit.TestCase;
import xpath.context.FakeContext;
import xpath.context.DynamicEnvironment;
import xpath.value.XPathString;
import xpath.value.XPathNumber;
import xpath.value.XPathBoolean;
import xpath.EvaluationException;


class VariableReferenceTest extends TestCase {
	
	function testVariables () {
		var environment = new DynamicEnvironment();
		environment.setVariable("a", new XPathString("foo"));
		environment.setVariable("b", new XPathNumber(123));
		environment.setVariable("c", new XPathBoolean(true));
		var context = new FakeContext(environment);
		
		var variableReference = new VariableReference("a");
		var result = variableReference.evaluate(context);
		assertTrue(Std.is(result, XPathString));
		assertEquals("foo", result.getString());
		
		variableReference = new VariableReference("b");
		result = variableReference.evaluate(context);
		assertTrue(Std.is(result, XPathNumber));
		assertEquals(123.0, result.getFloat());
		
		variableReference = new VariableReference("c");
		result = variableReference.evaluate(context);
		assertTrue(Std.is(result, XPathBoolean));
		assertTrue(result.getBool());
		
		variableReference = new VariableReference("d");
		var caught = false;
		try {
			result = variableReference.evaluate(context);
		} catch (e:EvaluationException) {
			caught = true;
		}
		assertTrue(caught);
	}
	
}

