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


package xpath.unit.expression;
import haxe.unit.TestCase;
import xpath.expression.Negation;
import xpath.expression.Number;
import xpath.expression.Literal;
import xpath.context.Context;
import xpath.context.DynamicEnvironment;
import xpath.type.XPathValue;
import xpath.type.XPathNumber;


class TestNegation extends TestCase {
	
	private function testAll () {
		for (testValue in [0, 1, 123.456, -789.012, 239585, -239582]) {
			var number:Number = new Number(testValue);
			var negation:Negation = new Negation(number);
			var context:Context = new Context(null, null, null, new DynamicEnvironment());
			var result:XPathValue = negation.evaluate(context);
			
			assertTrue(Std.is(result, XPathNumber));
			assertEquals(-testValue, result.xPathValueApi.getFloat());
			
			var literal:Literal = new Literal(Std.string(testValue));
			negation = new Negation(literal);
			result = negation.evaluate(context);
			
			assertTrue(Std.is(result, XPathNumber));
			assertEquals(-testValue, result.xPathValueApi.getFloat());
		}
	}
	
}