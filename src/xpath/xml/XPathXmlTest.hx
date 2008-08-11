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


package xpath.xml;
import haxe.unit.TestCase;
import xpath.xml.XPathHxXml;
import xpath.xml.XmlNodeType;
import xpath.XPathException;
import xpath.Axis;


class XPathXmlTest extends TestCase {
	
	/* <a>
	 *     text1
	 *     <b/>
	 *     text2
	 *     <c>
	 *         text3
	 *         <d/>
	 *         text4 text5 text6
	 *         <e foo="123" bar="456">
	 *             text7
	 *             <f/>
	 *             <g/>
	 *         </e>
	 *         <h>
	 *             <i blib="abc" blob="def" />
	 *             text8 text9
	 *         </h>
	 *         <j/>
	 *     </c>
	 *     <k>
	 *         <l/>
	 *     </k>
	 *     <m/>
	 * </a> */
	var xml :Xml;
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
	
	
	public function new () {
		super();
		xml = Xml.createDocument();
		
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
		text2 = Xml.createPCData("text2");
		text3 = Xml.createPCData("text3");
		text4 = Xml.createPCData("text4");
		text5 = Xml.createPCData("text5");
		text6 = Xml.createPCData("text6");
		text7 = Xml.createPCData("text7");
		text8 = Xml.createPCData("text8");
		text9 = Xml.createPCData("text9");
		text10 = Xml.createPCData("text10");
		text11 = Xml.createPCData("text11");
		
		xml.addChild(a);
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
	}
	
	function testGetStringValue () {
		var xmlNode = XPathHxXml.wrapNode(text1);
		assertEquals("text1", xmlNode.getStringValue());
		
		for (hxXml in [ text4, text5, text6 ]) {
			xmlNode = XPathHxXml.wrapNode(hxXml);
			assertEquals("text4text5text6", xmlNode.getStringValue());
		}
		
		xmlNode = XPathHxXml.wrapNode(c);
		assertEquals(
			"text3text4text5text6text7text8text9",
			xmlNode.getStringValue()
		);
		
		xmlNode = XPathHxXml.wrapAttribute(e, "foo");
		assertEquals("123", xmlNode.getStringValue());
	}
	
	function testGetAncestorIterator () {
		var xmlNode = XPathHxXml.wrapNode(h);
		var iterable = xmlNode.getAxisIterable(Ancestor);
		for (iterator in [
			xmlNode.getAncestorIterator(),
			xmlNode.getAxisIterator(Ancestor),
			iterable.iterator(), iterable.iterator()
		]) {
			for (expectedResult in [ c, a, xml ]) {
				assertTrue(iterator.hasNext());
				assertEquals(
					expectedResult,
					cast(iterator.next(), XPathHxXml).getWrappedXml()
				);
			}
			assertFalse(iterator.hasNext());
		}
	}
	
	function testGetAncestorOrSelfIterator () {
		var xmlNode = XPathHxXml.wrapNode(h);
		var iterable = xmlNode.getAxisIterable(AncestorOrSelf);
		for (iterator in [
			xmlNode.getAncestorOrSelfIterator(),
			xmlNode.getAxisIterator(AncestorOrSelf),
			iterable.iterator(), iterable.iterator()
		]) {
			for (expectedResult in [ h, c, a, xml ]) {
				assertTrue(iterator.hasNext());
				assertEquals(
					expectedResult,
					cast(iterator.next(), XPathHxXml).getWrappedXml()
				);
			}
			assertFalse(iterator.hasNext());
		}
	}
	
	function testGetDescendantIterator () {
		var xmlNode = XPathHxXml.wrapNode(c);
		var iterable = xmlNode.getAxisIterable(Descendant);
		for (iterator in [
			xmlNode.getDescendantIterator(),
			xmlNode.getAxisIterator(Descendant),
			iterable.iterator(), iterable.iterator()
		]) {
			for (expectedResult in [
				text3, d, text4, e, text7, f, g, h, i, text8, j
			]) {
				assertTrue(iterator.hasNext());
				assertEquals(
					expectedResult,
					cast(iterator.next(), XPathHxXml).getWrappedXml()
				);
			}
			assertFalse(iterator.hasNext());
		}
	}
	
	function testGetDescendantOrSelfIterator () {
		var xmlNode = XPathHxXml.wrapNode(c);
		var iterable = xmlNode.getAxisIterable(DescendantOrSelf);
		for (iterator in [
			xmlNode.getDescendantOrSelfIterator(),
			xmlNode.getAxisIterator(DescendantOrSelf),
			iterable.iterator(), iterable.iterator()
		]) {
			for (expectedResult in [
				c, text3, d, text4, e, text7, f, g, h, i, text8, j
			]) {
				assertTrue(iterator.hasNext());
				assertEquals(
					expectedResult,
					cast(iterator.next(), XPathHxXml).getWrappedXml()
				);
			}
			assertFalse(iterator.hasNext());
		}
	}
	
	function testGetParentIterator () {
		var xmlNode = XPathHxXml.wrapNode(d);
		var iterable = xmlNode.getAxisIterable(Parent);
		for (iterator in [
			xmlNode.getParentIterator(),
			xmlNode.getAxisIterator(Parent),
			iterable.iterator(), iterable.iterator()
		]) {
			assertTrue(iterator.hasNext());
			assertEquals(c, cast(iterator.next(), XPathHxXml).getWrappedXml());
			assertFalse(iterator.hasNext());
		}
		
		xmlNode = XPathHxXml.wrapNode(xml);
		iterable = xmlNode.getAxisIterable(Parent);
		for (iterator in [
			xmlNode.getParentIterator(),
			xmlNode.getAxisIterator(Parent),
			iterable.iterator(), iterable.iterator()
		]) assertFalse(iterator.hasNext());
	}
	
	function testGetSelfIterator () {
		var xmlNode = XPathHxXml.wrapNode(d);
		var iterable = xmlNode.getAxisIterable(Self);
		for (iterator in [
			xmlNode.getSelfIterator(),
			xmlNode.getAxisIterator(Self),
			iterable.iterator(), iterable.iterator()
		]) {
			assertTrue(iterator.hasNext());
			assertEquals(d, cast(iterator.next(), XPathHxXml).getWrappedXml());
			assertFalse(iterator.hasNext());
		}
	}
	
	function testGetDocumentIterator () {
		var xmlNode = XPathHxXml.wrapNode(text4);
		var iterator = xmlNode.getDocumentIterator();
		for (expectedResult in [
			xml, a, text1, b, text2, c, text3, d, text4, e, text7, f,
			g, h, i, text8, j, k, l, m
		]) {
			assertTrue(iterator.hasNext());
			assertEquals(
				expectedResult,
				cast(iterator.next(), XPathHxXml).getWrappedXml()
			);
			if (expectedResult.nodeType == Xml.Element) {
				for (dummy in expectedResult.attributes()) {
					assertTrue(iterator.hasNext());
					var wrappedAttribute = iterator.next();
					assertEquals(Attribute, wrappedAttribute.getType());
					var name = wrappedAttribute.getName();
					assertTrue(expectedResult.exists(name));
					assertEquals(
						expectedResult.get(name),
						wrappedAttribute.getValue()
					);
				}
			}
		}
	}
	
}
