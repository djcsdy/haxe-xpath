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
import xpath.expression.Number;
import xpath.context.Context;
import xpath.context.DynamicEnvironment;
import xpath.type.XPathValue;
import xpath.type.XPathNumber;


class TestNumber extends TestCase {
	
	private function testAll () {
		for (testValue in [0, 1, 123.456, -789.012, 239585, -239582]) {
			var number:Number = new Number(testValue);
			var context:Context = new Context(null, null, null, new DynamicEnvironment());
			var numberValue:XPathValue = number.evaluate(context);
			
			assertTrue(Std.is(numberValue, XPathNumber));
			assertEquals(testValue, cast(numberValue, XPathNumber).getFloat());
		}
	}
	
}