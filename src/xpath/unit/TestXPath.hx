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


package xpath.unit;
import haxe.unit.TestCase;
import dcxml.Xml;
import xpath.XPath;
import xpath.XPathParseException;
import xpath.XPathEvaluationException;
import xpath.type.XPathValue;
import xpath.type.XPathNumber;
import xpath.type.XPathBoolean;


class TestXPath extends TestCase {
	
	/* <a>
	 *     <b/>
	 *     <c name="foo"/>
	 *     <d name="bar">
	 *         <e name="foo"/>
	 *     </d>
	 * </a> */
	private var xml:Xml;
	private var a:Xml;
	private var b:Xml;
	private var c:Xml;
	private var d:Xml;
	private var e:Xml;
	
	
	public function new () {
		super();
		
		xml = Xml.createDocument();
		a = Xml.createElement("a");
		b = Xml.createElement("b");
		c = Xml.createElement("c");
		d = Xml.createElement("d");
		e = Xml.createElement("e");	
		
		c.setAttributeValue("name", "foo");
		d.setAttributeValue("name", "bar");
		e.setAttributeValue("name", "foo");
		
		xml.addChild(a);
		a.addChild(b);
		a.addChild(c);
		a.addChild(d);
		d.addChild(e);
	}
	
	private function testOneStep () {
		var xpathObj:XPath = new XPath("node()");
		var nodes:Array<Xml> = xpathObj.selectNodes(xml);
		assertEquals(1, nodes.length);
		assertEquals(a, nodes[0]);

		xpathObj = new XPath("descendant::node()");
		nodes = xpathObj.selectNodes(xml);
		assertEquals(5, nodes.length);
		assertEquals(a, nodes[0]);
		assertEquals(b, nodes[1]);
		assertEquals(c, nodes[2]);
		assertEquals(d, nodes[3]);
		assertEquals(e, nodes[4]);
	}
	
	private function testTwoStep () {
		var xpathObj:XPath = new XPath("/node()");
		var nodes:Array<Xml> = xpathObj.selectNodes(e);
		assertEquals(1, nodes.length);
		assertEquals(a, nodes[0]);
	}
	
	private function testDeepStep () {
		var xpathObj:XPath = new XPath("//node()");
		var nodes:Array<Xml> = xpathObj.selectNodes(b);
		assertEquals(5, nodes.length);
		assertEquals(a, nodes[0]);
		assertEquals(b, nodes[1]);
		assertEquals(c, nodes[2]);
		assertEquals(d, nodes[3]);
		assertEquals(e, nodes[4]);
	}
	
	private function testRoot () {
		var xpathObj:XPath = new XPath("/");
		var nodes:Array<Xml> = xpathObj.selectNodes(b);
		assertEquals(1, nodes.length);
		assertEquals(xml, nodes[0]);
	}
	
	private function testAbbreviatedStep () {
		var xpathObj:XPath = new XPath(".");
		var nodes:Array<Xml> = xpathObj.selectNodes(a);
		assertEquals(1, nodes.length);
		assertEquals(a, nodes[0]);
		
		var xpathObj:XPath = new XPath("..");
		var nodes:Array<Xml> = xpathObj.selectNodes(a);
		assertEquals(1, nodes.length);
		assertEquals(xml, nodes[0]);
	}
	
	private function testPredicate () {
		var xpathObj:XPath = new XPath("node()[1]");
		var nodes:Array<Xml> = xpathObj.selectNodes(a);
		assertEquals(1, nodes.length);
		assertEquals(b, nodes[0]);
		
		xpathObj = new XPath("node()[3]");
		nodes = xpathObj.selectNodes(a);
		assertEquals(1, nodes.length);
		assertEquals(d, nodes[0]);
	}
	
	private function testDeepStepPredicate () {
		var xpathObj:XPath = new XPath("//node()[1]");
		var nodes:Array<Xml> = xpathObj.selectNodes(c);
		assertEquals(3, nodes.length);
		assertEquals(a, nodes[0]);
		assertEquals(b, nodes[1]);
		assertEquals(e, nodes[2]);
	}
	
	private function testGroup () {
		var xpathObj:XPath = new XPath("(//node()[1])");
		var nodes:Array<Xml> = xpathObj.selectNodes(c);
		assertEquals(3, nodes.length);
		assertEquals(a, nodes[0]);
		assertEquals(b, nodes[1]);
		assertEquals(e, nodes[2]);
	}
		
	private function testGroupPredicate () {
		var xpathObj:XPath = new XPath("(//node()[1])[3]");
		var nodes:Array<Xml> = xpathObj.selectNodes(c);
		assertEquals(1, nodes.length);
		assertEquals(e, nodes[0]);
	}
	
	private function testFunction () {
		var xpathObj:XPath = new XPath("true()");
		var result:XPathValue = xpathObj.evaluate(xml);
		assertTrue(Std.is(result, XPathBoolean));
		assertTrue(result.xPathValueApi.getBool());
	}
	
	private function testOperation1 () {
		var xpathObj:XPath = new XPath("1 + 1");
		var result:XPathValue = xpathObj.evaluate(xml);
		assertTrue(Std.is(result, XPathNumber));
		assertEquals(2.0, result.xPathValueApi.getFloat());
	}
	
	private function testOperation2 () {
		var xpathObj:XPath = new XPath("1+1 = 2");
		var result:XPathValue = xpathObj.evaluate(xml);
		assertTrue(Std.is(result, XPathBoolean));
		assertTrue(result.xPathValueApi.getBool());
	}
	
	private function testOperation3 () {
		var xpathObj:XPath = new XPath("1+2 *3 = 7");
		var result:XPathValue = xpathObj.evaluate(xml);
		assertTrue(Std.is(result, XPathBoolean));
		assertTrue(result.xPathValueApi.getBool());
	}
	
	private function testComplex1 () {
		var xpathObj:XPath = new XPath("//node()[@name='foo']");
		var nodes:Array<Xml> = xpathObj.selectNodes(xml);
		assertEquals(2, nodes.length);
		assertEquals(c, nodes[0]);
		assertEquals(e, nodes[1]);
	}
	
	private function testComplex2 () {
		var xpathObj:XPath = new XPath("//node()[@name='foo'][../@name='bar']");
		var nodes:Array<Xml> = xpathObj.selectNodes(xml);
		assertEquals(1, nodes.length);
		assertEquals(e, nodes[0]);
	}
	
	private function testComplex3 () {
		var xpathObj:XPath = new XPath("//node()[@name='foo' and ../@name='bar']");
		var nodes:Array<Xml> = xpathObj.selectNodes(xml);
		assertEquals(1, nodes.length);
		assertEquals(e, nodes[0]);
	}
	
	private function testSyntaxError () {
		var caught:Bool = false;
		try {
			var xpathObj:XPath = new XPath("1++1");
		} catch (e:XPathParseException) {
			caught = true;
		}
		assertTrue(caught);
	}
	
	private function testWrongType () {
		var xpathObj:XPath = new XPath("123");
		var caught:Bool = false;
		try {
			xpathObj.selectNodes(xml);
		} catch (e:XPathEvaluationException) {
			caught = true;
		}
		assertTrue(caught);
	}
	
}