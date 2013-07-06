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


package xpath.value;
import Haxe.unit.TestCase;
import xpath.value.XPathNodeSet;
import xpath.value.XPathString;
import xpath.value.XPathNumber;
import xpath.value.XPathBoolean;
import xpath.value.XPathValue;
import xpath.xml.XPathHxXml;
import xpath.xml.XPathXml;
import xpath.EvaluationException;


class XPathNodeSetTest extends TestCase {
	
	/* <a>
	 *     text1
	 *     <b/>
	 *     3.14159
	 *     <c>
	 *         text3
	 *         <d/>
	 *         text4 3.14159 text6
	 *         <e foo="123" bar="456">
	 *             text7
	 *             <f/>
	 *             <g/>
	 *         </e>
	 *         <h>
	 *             <i blib="abc" blob="def" />
	 *             12. 345
	 *         </h>
	 *         <j/>
	 *     </c>
	 *     <k>
	 *         <l/>
	 *     </k>
	 *     <m/>
	 * </a> */
	var root :Xml;
	var a :Xml;
	var b :Xml;
	var c :Xml;
	var d :Xml;
	var e :Xml;
	var f :Xml;
	var g :Xml;
	var h :Xml;
	var i :Xml;
	var j :Xml;
	var k :Xml;
	var l :Xml;
	var m :Xml;
	var text1 :Xml;
	var text2 :Xml;
	var text3 :Xml;
	var text4 :Xml;
	var text5 :Xml;
	var text6 :Xml;
	var text7 :Xml;
	var text8 :Xml;
	var text9 :Xml;
	var text10 :Xml;
	var text11 :Xml;
	
	var xRoot :XPathXml;
	var xA :XPathXml;
	var xB :XPathXml;
	var xC :XPathXml;
	var xD :XPathXml;
	var xE :XPathXml;
	var xF :XPathXml;
	var xG :XPathXml;
	var xH :XPathXml;
	var xI :XPathXml;
	var xJ :XPathXml;
	var xK :XPathXml;
	var xL :XPathXml;
	var xM :XPathXml;
	var xText1 :XPathXml;
	var xText2 :XPathXml;
	var xText3 :XPathXml;
	var xText4 :XPathXml;
	var xText7 :XPathXml;
	var xText8 :XPathXml;
	var xEFoo :XPathXml;
	var xEBar :XPathXml;
	var xIBlib :XPathXml;
	var xIBlob :XPathXml;
	
	
	public function new () {
		super();
		root = Xml.createDocument();
		
		a = Xml.createElement("a");
		b = Xml.createElement("b");
		c = Xml.createElement("c");
		d = Xml.createElement("d");
		e = Xml.createElement("e");
		f = Xml.createElement("f");
		g = Xml.createElement("g");
		h = Xml.createElement("h");
		i = Xml.createElement("i");
		j = Xml.createElement("j");
		k = Xml.createElement("k");
		l = Xml.createElement("l");
		m = Xml.createElement("m");
		
		text1 = Xml.createPCData("text1");
		text2 = Xml.createPCData("3.14159");
		text3 = Xml.createPCData("text3");
		text4 = Xml.createPCData("text4");
		text5 = Xml.createPCData("3.14159");
		text6 = Xml.createPCData("text6");
		text7 = Xml.createPCData("text7");
		text8 = Xml.createPCData("12.");
		text9 = Xml.createPCData("345");
		text10 = Xml.createPCData("text10");
		text11 = Xml.createPCData("text11");
		
		root.addChild(a);
		a.addChild(text1);
		a.addChild(b);
		a.addChild(text2);
		a.addChild(c);
		c.addChild(text3);
		c.addChild(d);
		c.addChild(text4);
		c.addChild(text5);
		c.addChild(text6);
		c.addChild(e);
		e.addChild(text7);
		e.addChild(f);
		e.addChild(g);
		c.addChild(h);
		h.addChild(i);
		h.addChild(text8);
		h.addChild(text9);
		c.addChild(j);
		a.addChild(k);
		k.addChild(l);
		a.addChild(m);
		
		e.set("foo", "123");
		e.set("bar", "456");
		i.set("blib", "abc");
		i.set("blob", "def");
		
		xRoot = XPathHxXml.wrapNode(root);
		xA = XPathHxXml.wrapNode(a);
		xB = XPathHxXml.wrapNode(b);
		xC = XPathHxXml.wrapNode(c);
		xD = XPathHxXml.wrapNode(d);
		xE = XPathHxXml.wrapNode(e);
		xF = XPathHxXml.wrapNode(f);
		xG = XPathHxXml.wrapNode(g);
		xH = XPathHxXml.wrapNode(h);
		xI = XPathHxXml.wrapNode(i);
		xJ = XPathHxXml.wrapNode(j);
		xK = XPathHxXml.wrapNode(k);
		xL = XPathHxXml.wrapNode(l);
		xM = XPathHxXml.wrapNode(m);
		xText1 = XPathHxXml.wrapNode(text1);
		xText2 = XPathHxXml.wrapNode(text2);
		xText3 = XPathHxXml.wrapNode(text3);
		xText4 = XPathHxXml.wrapNode(text4);
		xText7 = XPathHxXml.wrapNode(text7);
		xText8 = XPathHxXml.wrapNode(text8);
		xEFoo = XPathHxXml.wrapAttribute(e, "foo");
		xEBar = XPathHxXml.wrapAttribute(e, "bar");
		xIBlib = XPathHxXml.wrapAttribute(i, "blib");
		xIBlob = XPathHxXml.wrapAttribute(i, "blob");
	}
	
	function testGetBool () {
		var xPathNodeSet = new XPathNodeSet([]);
		assertFalse(xPathNodeSet.getBool());
		
		for (nodes in [
			[ xA ],
			[ xA, xB, xC ],
			[ xText8, xF, xEFoo ]
		]) {
			xPathNodeSet = new XPathNodeSet(nodes);
			assertTrue(xPathNodeSet.getBool());
		}
	}
	
	function testGetFloat () {
		var xPathNodeSet = new XPathNodeSet([ xText2 ]);
		#if flash8
		// something *really* weird with parseFloat on Flash8
		assertTrue(
			xPathNodeSet.getFloat() > 3.14158 &&
			xPathNodeSet.getFloat() < 3.14160
		);
		#else
		assertEquals(3.14159, xPathNodeSet.getFloat());
		#end
		
		xPathNodeSet = new XPathNodeSet([ xText2, xText4, xText8 ]);
		#if flash8
		// something *really* weird with parseFloat on Flash8
		assertTrue(
			xPathNodeSet.getFloat() > 3.14158 &&
			xPathNodeSet.getFloat() < 3.14160
		);
		#else
		assertEquals(3.14159, xPathNodeSet.getFloat());
		#end
		
		xPathNodeSet = new XPathNodeSet([ xText4 ]);
		assertTrue(Math.isNaN(xPathNodeSet.getFloat()));
		
		xPathNodeSet = new XPathNodeSet([ xText8 ]);
		#if flash8
		// something *really* weird with parseFloat on Flash8
		assertTrue(
			xPathNodeSet.getFloat() > 12.344 &&
			xPathNodeSet.getFloat() < 12.346
		);
		#else
		assertEquals(12.345, xPathNodeSet.getFloat());
		#end
	}
	
	function testGetString () {
		var xPathNodeSet = new XPathNodeSet([ xA ]);
		assertEquals(
			"text13.14159text3text43.14159text6text712.345",
			xPathNodeSet.getString()
		);
		
		xPathNodeSet = new XPathNodeSet([ xText4 ]);
		assertEquals("text43.14159text6", xPathNodeSet.getString());
		
		xPathNodeSet = new XPathNodeSet([ xL, xE, xH ]);
		assertEquals("text7", xPathNodeSet.getString());
	}
	
	function testGetNodes () {
		var nodes = [ xC, xText7, xI ];
		var xPathNodeSet = new XPathNodeSet(nodes);
		var nodesIterator = nodes.iterator();
		for (node in xPathNodeSet.getNodes()) {
			assertTrue(nodesIterator.hasNext());
			assertEquals(nodesIterator.next(), node);
		}
		assertFalse(nodesIterator.hasNext());
	}
	
	function testGetNodesDocumentOrder () {
		var xPathNodeSet = new XPathNodeSet([
			xJ, xRoot, xIBlib, xC, xA, xText8, xEFoo
		]);
		var nodesDocumentOrder = [
			xRoot, xA, xC, xEFoo, xIBlib, xText8, xJ
		].iterator();
		for (node in xPathNodeSet.getNodesDocumentOrder()) {
			assertTrue(nodesDocumentOrder.hasNext());
			assertTrue(nodesDocumentOrder.next().is(node));
		}
		assertFalse(nodesDocumentOrder.hasNext());
		
		xPathNodeSet = new XPathNodeSet([]);
		assertFalse(xPathNodeSet.getNodesDocumentOrder().iterator().hasNext());
	}
	
	function testGetFirstNodeDocumentOrder () {
		var xPathNodeSet = new XPathNodeSet([ xJ, xRoot, xC, xA, xText8 ]);
		assertTrue(xRoot.is(xPathNodeSet.getFirstNodeDocumentOrder()));
		
		xPathNodeSet = new XPathNodeSet([ xJ, xC, xText1, xText8 ]);
		assertTrue(xText1.is(xPathNodeSet.getFirstNodeDocumentOrder()));
		
		xPathNodeSet = new XPathNodeSet([ xK, xM, xText8, xEBar, xIBlob, xH ]);
		assertTrue(xEBar.is(xPathNodeSet.getFirstNodeDocumentOrder()));
		
		var caught = false;
		xPathNodeSet = new XPathNodeSet([]);
		try {
			xPathNodeSet.getFirstNodeDocumentOrder();
		} catch (exception:EvaluationException) {
			caught = true;
		}
		assertTrue(caught);
	}
	
	function testEquals () {
		var leftOp = new XPathNodeSet([ xRoot, xC, xE ]);
		var rightOp:XPathValue = new XPathNodeSet([ xA ]);
		assertTrue(leftOp.equals(rightOp).getBool());
		assertTrue(rightOp.equals(leftOp).getBool());
		
		rightOp = new XPathNodeSet([ xK, xText7, xM ]);
		assertTrue(leftOp.equals(rightOp).getBool());
		assertTrue(rightOp.equals(leftOp).getBool());
		
		rightOp = new XPathNodeSet([ xK, xH ]);
		assertFalse(leftOp.equals(rightOp).getBool());
		assertFalse(rightOp.equals(leftOp).getBool());
		
		leftOp = new XPathNodeSet([ xText8 ]);
		assertTrue(leftOp.equals(rightOp).getBool());
		assertTrue(rightOp.equals(leftOp).getBool());
		
		rightOp = new XPathString("12.345");
		assertTrue(leftOp.equals(rightOp).getBool());
		assertTrue(rightOp.equals(leftOp).getBool());
		
		leftOp = new XPathNodeSet([ xH, xA ]);
		assertTrue(leftOp.equals(rightOp).getBool());
		assertTrue(rightOp.equals(leftOp).getBool());
		
		leftOp = new XPathNodeSet([ xC, xEBar ]);
		assertFalse(leftOp.equals(rightOp).getBool());
		assertFalse(rightOp.equals(leftOp).getBool());
		
		rightOp = new XPathNumber(456);
		assertTrue(leftOp.equals(rightOp).getBool());
		assertTrue(rightOp.equals(leftOp).getBool());
	}
	
	function testNotEqual () {
		var leftOp = new XPathNodeSet([ xRoot ]);
		var rightOp = new XPathNodeSet([ xA ]);
		assertFalse(leftOp.notEqual(rightOp).getBool());
		assertFalse(rightOp.notEqual(leftOp).getBool());
		
		rightOp = new XPathNodeSet([ xA, xText3 ]);
		assertTrue(leftOp.notEqual(rightOp).getBool());
		assertTrue(rightOp.notEqual(leftOp).getBool());
	}
	
	function testLessThan () {
		var nodeSet = new XPathNodeSet([ xText2, xText8, xEFoo ]);
		var number = new XPathNumber(1.2);
		var string = new XPathString("   1.2 ");
		assertTrue(number.lessThan(nodeSet).getBool());
		assertTrue(string.lessThan(nodeSet).getBool());
		assertFalse(nodeSet.lessThan(number).getBool());
		assertFalse(nodeSet.lessThan(string).getBool());
		
		number = new XPathNumber(4);
		string = new XPathString("4  ");
		assertTrue(number.lessThan(nodeSet).getBool());
		assertTrue(string.lessThan(nodeSet).getBool());
		assertTrue(nodeSet.lessThan(number).getBool());
		assertTrue(nodeSet.lessThan(string).getBool());
		
		number = new XPathNumber(123);
		string = new XPathString(" 123 ");
		assertFalse(number.lessThan(nodeSet).getBool());
		assertFalse(string.lessThan(nodeSet).getBool());
		assertTrue(nodeSet.lessThan(number).getBool());
		assertTrue(nodeSet.lessThan(string).getBool());
		
		number = new XPathNumber(3957835);
		string = new XPathString("3957835");
		assertFalse(number.lessThan(nodeSet).getBool());
		assertFalse(string.lessThan(nodeSet).getBool());
		assertTrue(nodeSet.lessThan(number).getBool());
		assertTrue(nodeSet.lessThan(string).getBool());
		
		nodeSet = new XPathNodeSet([ xEFoo, xEBar ]);
		number = new XPathNumber(123);
		string = new XPathString(" 123 ");
		assertTrue(number.lessThan(nodeSet).getBool());
		assertTrue(string.lessThan(nodeSet).getBool());
		assertFalse(nodeSet.lessThan(string).getBool());
		assertFalse(nodeSet.lessThan(string).getBool());
	}
	
	function testGreaterThan () {
		var nodeSet = new XPathNodeSet([ xText2, xText8, xEFoo ]);
		var number = new XPathNumber(1.2);
		var string = new XPathString("   1.2 ");
		assertFalse(number.greaterThan(nodeSet).getBool());
		assertFalse(string.greaterThan(nodeSet).getBool());
		assertTrue(nodeSet.greaterThan(number).getBool());
		assertTrue(nodeSet.greaterThan(string).getBool());
		
		number = new XPathNumber(4);
		string = new XPathString("4  ");
		assertTrue(number.greaterThan(nodeSet).getBool());
		assertTrue(string.greaterThan(nodeSet).getBool());
		assertTrue(nodeSet.greaterThan(number).getBool());
		assertTrue(nodeSet.greaterThan(string).getBool());
		
		number = new XPathNumber(123);
		string = new XPathString(" 123 ");
		assertTrue(number.greaterThan(nodeSet).getBool());
		assertTrue(string.greaterThan(nodeSet).getBool());
		assertFalse(nodeSet.greaterThan(number).getBool());
		assertFalse(nodeSet.greaterThan(string).getBool());
		
		number = new XPathNumber(3957835);
		string = new XPathString("3957835");
		assertTrue(number.greaterThan(nodeSet).getBool());
		assertTrue(string.greaterThan(nodeSet).getBool());
		assertFalse(nodeSet.greaterThan(number).getBool());
		assertFalse(nodeSet.greaterThan(string).getBool());
		
		nodeSet = new XPathNodeSet([ xEFoo, xEBar ]);
		number = new XPathNumber(123);
		string = new XPathString(" 123 ");
		assertFalse(number.greaterThan(nodeSet).getBool());
		assertFalse(string.greaterThan(nodeSet).getBool());
		assertTrue(nodeSet.greaterThan(string).getBool());
		assertTrue(nodeSet.greaterThan(string).getBool());
	}
	
	function testLessThanOrEqual () {
		var nodeSet = new XPathNodeSet([ xText2, xText8, xEFoo ]);
		var number = new XPathNumber(1.2);
		var string = new XPathString("   1.2 ");
		assertTrue(number.lessThanOrEqual(nodeSet).getBool());
		assertTrue(string.lessThanOrEqual(nodeSet).getBool());
		assertFalse(nodeSet.lessThanOrEqual(number).getBool());
		assertFalse(nodeSet.lessThanOrEqual(string).getBool());
		
		number = new XPathNumber(4);
		string = new XPathString("4  ");
		assertTrue(number.lessThanOrEqual(nodeSet).getBool());
		assertTrue(string.lessThanOrEqual(nodeSet).getBool());
		assertTrue(nodeSet.lessThanOrEqual(number).getBool());
		assertTrue(nodeSet.lessThanOrEqual(string).getBool());
		
		number = new XPathNumber(123);
		string = new XPathString(" 123 ");
		assertTrue(number.lessThanOrEqual(nodeSet).getBool());
		assertTrue(string.lessThanOrEqual(nodeSet).getBool());
		assertTrue(nodeSet.lessThanOrEqual(number).getBool());
		assertTrue(nodeSet.lessThanOrEqual(string).getBool());
		
		number = new XPathNumber(3957835);
		string = new XPathString("3957835");
		assertFalse(number.lessThanOrEqual(nodeSet).getBool());
		assertFalse(string.lessThanOrEqual(nodeSet).getBool());
		assertTrue(nodeSet.lessThanOrEqual(number).getBool());
		assertTrue(nodeSet.lessThanOrEqual(string).getBool());
		
		nodeSet = new XPathNodeSet([ xEFoo, xEBar ]);
		number = new XPathNumber(123);
		string = new XPathString(" 123 ");
		assertTrue(number.lessThanOrEqual(nodeSet).getBool());
		assertTrue(string.lessThanOrEqual(nodeSet).getBool());
		assertTrue(nodeSet.lessThanOrEqual(string).getBool());
		assertTrue(nodeSet.lessThanOrEqual(string).getBool());
	}
	
	function testGreaterThanOrEqual () {
		var nodeSet = new XPathNodeSet([ xText2, xText8, xEFoo ]);
		var number = new XPathNumber(1.2);
		var string = new XPathString("   1.2 ");
		assertFalse(number.greaterThanOrEqual(nodeSet).getBool());
		assertFalse(string.greaterThanOrEqual(nodeSet).getBool());
		assertTrue(nodeSet.greaterThanOrEqual(number).getBool());
		assertTrue(nodeSet.greaterThanOrEqual(string).getBool());
		
		number = new XPathNumber(4);
		string = new XPathString("4  ");
		assertTrue(number.greaterThanOrEqual(nodeSet).getBool());
		assertTrue(string.greaterThanOrEqual(nodeSet).getBool());
		assertTrue(nodeSet.greaterThanOrEqual(number).getBool());
		assertTrue(nodeSet.greaterThanOrEqual(string).getBool());
		
		number = new XPathNumber(123);
		string = new XPathString(" 123 ");
		assertTrue(number.greaterThanOrEqual(nodeSet).getBool());
		assertTrue(string.greaterThanOrEqual(nodeSet).getBool());
		assertTrue(nodeSet.greaterThanOrEqual(number).getBool());
		assertTrue(nodeSet.greaterThanOrEqual(string).getBool());
		
		number = new XPathNumber(3957835);
		string = new XPathString("3957835");
		assertTrue(number.greaterThanOrEqual(nodeSet).getBool());
		assertTrue(string.greaterThanOrEqual(nodeSet).getBool());
		assertFalse(nodeSet.greaterThanOrEqual(number).getBool());
		assertFalse(nodeSet.greaterThanOrEqual(string).getBool());
		
		nodeSet = new XPathNodeSet([ xEFoo, xEBar ]);
		number = new XPathNumber(123);
		string = new XPathString(" 123 ");
		assertTrue(number.greaterThanOrEqual(nodeSet).getBool());
		assertTrue(string.greaterThanOrEqual(nodeSet).getBool());
		assertTrue(nodeSet.greaterThanOrEqual(string).getBool());
		assertTrue(nodeSet.greaterThanOrEqual(string).getBool());
	}
	
	function testUnion () {
		var leftOp = new XPathNodeSet([ xEFoo, xRoot, xA ]);
		var rightOp = new XPathNodeSet([ xE, xA, xText2, xK ]);
		
		var expectedNodesIterator = [
			xEFoo, xRoot, xA, xE, xA, xText2, xK
		].iterator();
		for (node in leftOp.union(rightOp).getNodes()) {
			assertTrue(expectedNodesIterator.hasNext());
			assertTrue(expectedNodesIterator.next().is(node));
		}
		
		expectedNodesIterator = [
			xEFoo, xRoot, xA, xE, xA, xText2, xK
		].iterator();
		for (node in leftOp.union(rightOp).getNodes()) {
			assertTrue(expectedNodesIterator.hasNext());
			assertTrue(expectedNodesIterator.next().is(node));
		}
		
		var caught = false;
		try {
			leftOp.union(new XPathBoolean(false));
		} catch (exception:EvaluationException) {
			caught = true;
		}
		assertTrue(caught);
		
		caught = false;
		try {
			leftOp.union(new XPathNumber(123));
		} catch (exception:EvaluationException) {
			caught = true;
		}
		assertTrue(caught);
		
		caught = false;
		try {
			leftOp.union(new XPathString("abc"));
		} catch (exception:EvaluationException) {
			caught = true;
		}
		assertTrue(caught);
	}
	
}
