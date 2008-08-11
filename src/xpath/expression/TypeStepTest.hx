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
import xpath.xml.XPathXml;
import xpath.xml.XPathHxXml;
import xpath.value.XPathNodeSet;
import xpath.NodeCategory;


class TypeStepTest extends TestCase {
	
	function testNode () {
		var typeStep = new TypeStep(NodeCategory.Node);
		var element:XPathXml = XPathHxXml.wrapNode(Xml.createElement("foo"));
		var result = typeStep.evaluate(new FakeContext(element));
		var nodes = Lambda.array(cast(result, XPathNodeSet).getNodes());
		assertEquals(1, nodes.length);
		assertEquals(element, nodes[0]);
	}
	
	function testText () {
		var typeStep = new TypeStep(NodeCategory.Text);
		var element = XPathHxXml.wrapNode(Xml.createElement("foo"));
		var text:XPathXml = XPathHxXml.wrapNode(Xml.createCData("blabla"));
		
		var result = typeStep.evaluate(new FakeContext(element));
		var nodes = Lambda.array(cast(result, XPathNodeSet).getNodes());
		assertEquals(0, nodes.length);
		
		result = typeStep.evaluate(new FakeContext(text));
		nodes = Lambda.array(cast(result, XPathNodeSet).getNodes());
		assertEquals(text, nodes[0]);
	}
	
}

