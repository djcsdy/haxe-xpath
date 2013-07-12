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


package xpath.library;
import haxe.unit.TestCase;
import xpath.context.FakeContext;
import xpath.value.XPathValue;
import xpath.value.XPathNumber;
import xpath.value.XPathString;
import xpath.value.XPathNodeSet;
import xpath.xml.XPathHxXml;
import xpath.xml.XPathXml;
import xpath.EvaluationException;


class NodeSetLibraryTest extends TestCase {
	
	function testLast () {
		var context = new FakeContext(0, 42);
		var result = NodeSetLibrary.last(context, []);
		assertTrue(Std.is(result, XPathNumber));
		assertEquals(42., result.getFloat());
		
		var caught = false;
		try {
			NodeSetLibrary.last(context, [
				cast(new XPathNumber(27), XPathValue)
			]);
		} catch (exception:EvaluationException) {
			caught = true;
		}
		assertTrue(caught);
	}
	
	function testPosition () {
		var context = new FakeContext(42);
		var result = NodeSetLibrary.position(context, []);
		assertTrue(Std.is(result, XPathNumber));
		assertEquals(42., result.getFloat());
		
		var caught = false;
		try {
			NodeSetLibrary.position(context, [
				cast(new XPathNumber(27), XPathValue)
			]);
		} catch (exception:EvaluationException) {
			caught = true;
		}
		assertTrue(caught);
	}
	
	function testCount () {
		var context = new FakeContext();
		var nodeSet = new XPathNodeSet([
			cast(XPathHxXml.wrapNode(Xml.createElement("a")), XPathXml),
			XPathHxXml.wrapNode(Xml.createCData("foo")),
			XPathHxXml.wrapNode(Xml.createElement("b"))
		]);
		var result = NodeSetLibrary.count(context, [
			cast(nodeSet, XPathValue)
		]);
		assertTrue(Std.is(result, XPathNumber));
		assertEquals(3., result.getFloat());
		
		var caught = false;
		try {
			NodeSetLibrary.count(context, []);
		} catch (exception:EvaluationException) {
			caught = true;
		}
		assertTrue(caught);
		
		caught = false;
		try {
			NodeSetLibrary.count(context, [
				cast(new XPathNumber(27), XPathValue)
			]);
		} catch (exception:EvaluationException) {
			caught = true;
		}
		assertTrue(caught);
		
		caught = false;
		try {
			NodeSetLibrary.count(context, [
				cast(nodeSet, XPathValue), nodeSet
			]);
		} catch (exception:EvaluationException) {
			caught = true;
		}
		assertTrue(caught);
	}
	
	function testLocalName () {
		var contextNode:XPathXml = XPathHxXml.wrapNode(
			Xml.createElement("foo")
		);
		var context = new FakeContext(contextNode);
		var result = NodeSetLibrary.localName(context, []);
		assertTrue(Std.is(result, XPathString));
		assertEquals("foo", result.getString());
		
		var a = Xml.createElement("a");
		var b = Xml.createElement("b");
		var c = Xml.createElement("c");
		a.addChild(b);
		a.addChild(c);
		var xPathB:XPathXml = XPathHxXml.wrapNode(b);
		var xPathC:XPathXml = XPathHxXml.wrapNode(c);
		var nodeSet = new XPathNodeSet([xPathC, xPathB]);
		var result = NodeSetLibrary.localName(context, [
			cast(nodeSet, XPathValue)
		]);
		assertTrue(Std.is(result, XPathString));
		assertEquals("b", result.getString());
		
		nodeSet = new XPathNodeSet([]);
		var caught = false;
		try {
			NodeSetLibrary.localName(context, [
				cast(nodeSet, XPathValue)
			]);
		} catch (exception:EvaluationException) {
			caught = true;
		}
		assertTrue(caught);
	}
	
	function testName () {
		var contextNode:XPathXml = XPathHxXml.wrapNode(
			Xml.createElement("foo")
		);
		var context = new FakeContext(contextNode);
		var result = NodeSetLibrary.nodeName(context, []);
		assertTrue(Std.is(result, XPathString));
		assertEquals("foo", result.getString());
		
		var a = Xml.createElement("a");
		var b = Xml.createElement("b");
		var c = Xml.createElement("c");
		a.addChild(b);
		a.addChild(c);
		var xPathB:XPathXml = XPathHxXml.wrapNode(b);
		var xPathC:XPathXml = XPathHxXml.wrapNode(c);
		var nodeSet = new XPathNodeSet([xPathC, xPathB]);
		var result = NodeSetLibrary.nodeName(context, [
			cast(nodeSet, XPathValue)
		]);
		assertTrue(Std.is(result, XPathString));
		assertEquals("b", result.getString());
		
		nodeSet = new XPathNodeSet([]);
		var caught = false;
		try {
			NodeSetLibrary.nodeName(context, [
				cast(nodeSet, XPathValue)
			]);
		} catch (exception:EvaluationException) {
			caught = true;
		}
		assertTrue(caught);
	}
	
}
