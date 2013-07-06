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
import haxe.unit.TestCase;
import xpath.context.FakeContext;
import xpath.value.XPathNodeSet;
import xpath.xml.XPathXml;
import xpath.xml.XPathHxXml;


class NameStepTest extends TestCase {
	
	function testNameStep () {
		var plainXmlElement = Xml.createElement("foo");
		plainXmlElement.set("foo", "bar");
		var element:XPathXml = XPathHxXml.wrapNode(plainXmlElement);
		var attribute:XPathXml = null;
		for (candAttribute in element.getAttributeIterator()) {
			attribute = candAttribute;
		}
		
		var nameStep = new NameStep("*");
		var result = nameStep.evaluate(new FakeContext(element));
		var nodes = Lambda.array(cast(result, XPathNodeSet).getNodes());
		assertEquals(1, nodes.length);
		assertEquals(element, nodes[0]);
		
		result = nameStep.evaluate(new FakeContext(attribute));
		nodes = Lambda.array(cast(result, XPathNodeSet).getNodes());
		assertEquals(1, nodes.length);
		assertEquals(attribute, nodes[0]);
		
		nameStep = new NameStep("foo");
		result = nameStep.evaluate(new FakeContext(element));
		nodes = Lambda.array(cast(result, XPathNodeSet).getNodes());
		assertEquals(1, nodes.length);
		assertEquals(element, nodes[0]);
		
		result = nameStep.evaluate(new FakeContext(attribute));
		nodes = Lambda.array(cast(result, XPathNodeSet).getNodes());
		assertEquals(1, nodes.length);
		assertEquals(attribute, nodes[0]);
		
		plainXmlElement = Xml.createElement("bat");
		element = XPathHxXml.wrapNode(plainXmlElement);
		result = nameStep.evaluate(new FakeContext(element));
		nodes = Lambda.array(cast(result, XPathNodeSet).getNodes());
		assertEquals(0, nodes.length);
		
		plainXmlElement.set("bat", "baz");
		for (candAttribute in element.getAttributeIterator()) {
			attribute = candAttribute;
		}
		result = nameStep.evaluate(new FakeContext(attribute));
		nodes = Lambda.array(cast(result, XPathNodeSet).getNodes());
		assertEquals(0, nodes.length);
	}
	
}
