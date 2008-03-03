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
import xpath.value.XPathNodeSet;
import xpath.xml.XPathXml;
import xpath.xml.XPathHxXml;


class PredicateStepTest extends TestCase {
	
	function testNumber () {
		var element:XPathXml = XPathHxXml.wrapNode(Xml.createElement("foo"));
		
		for (position in [1, 5, 10]) {
			for (expressionValue in [1, 5, 10]) {
				var expression = new Number(expressionValue);
				var predicateStep = new PredicateStep(expression);
				var result = predicateStep.evaluate(new FakeContext(
					element, position, 20
				));
				var nodes = Lambda.array(
					cast(result, XPathNodeSet).getNodes()
				);
				
				if (position == expressionValue) {
					assertEquals(1, nodes.length);
					assertEquals(element, nodes[0]);
				} else {
					assertEquals(0, nodes.length);
				}
			}
		}
	}
	
	function testBool () {
		var element:XPathXml = XPathHxXml.wrapNode(Xml.createElement("foo"));
		
		var predicateStep = new PredicateStep(
			new FakeBooleanExpression(true)
		);
		var result = predicateStep.evaluate(new FakeContext(element));
		var nodes = Lambda.array(cast(result, XPathNodeSet).getNodes());
		assertEquals(1, nodes.length);
		assertEquals(element, nodes[0]);
		
		predicateStep = new PredicateStep(new FakeBooleanExpression(false));
		result = predicateStep.evaluate(new FakeContext(element));
		nodes = Lambda.array(cast(result, XPathNodeSet).getNodes());
		assertEquals(0, nodes.length);
	}
	
}
