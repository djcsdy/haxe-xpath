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


package xpath.xml;
import haxe.unit.TestCase;
import xpath.xml.XPathHxXml;
import xpath.xml.XPathXml;
import xpath.xml.XmlNodeType;
import xpath.XPathException;
import xpath.Axis;


class XPathHxXmlTest extends TestCase {
	
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
	
	function testWrap () {
		var xml;
		var hxXmlNode;
		var caught;
		
		#if !flash8
		var xml = Xml.createComment("foo");
		var hxXmlNode = XPathHxXml.wrapNode(xml);
		assertEquals(xml, hxXmlNode.getWrappedXml());
		assertEquals(Comment, hxXmlNode.getType());
		
		xml = Xml.createDocType("bar");
		caught = false;
		try {
			XPathHxXml.wrapNode(xml);
		} catch (exception:XPathException) {
			caught = true;
		}
		assertTrue(caught);
		#end
		
		xml = Xml.createDocument();
		hxXmlNode = XPathHxXml.wrapNode(xml);
		assertEquals(xml, hxXmlNode.getWrappedXml());
		assertEquals(Root, hxXmlNode.getType());
		
		xml = Xml.createElement("bat");
		hxXmlNode = XPathHxXml.wrapNode(xml);
		assertEquals(xml, hxXmlNode.getWrappedXml());
		assertEquals(Element, hxXmlNode.getType());
		
		#if !flash8
		xml = Xml.createProlog("baz");
		hxXmlNode = XPathHxXml.wrapNode(xml);
		assertEquals(xml, hxXmlNode.getWrappedXml());
		assertEquals(ProcessingInstruction, hxXmlNode.getType());
		#end
		
		xml = Xml.createElement("qzzz");
		xml.set("wrt", "ping");
		xml.set("aruga", "honk");
		
		hxXmlNode = XPathHxXml.wrapAttribute(xml, "wrt");
		assertEquals(Attribute, hxXmlNode.getType());
		assertEquals("wrt", hxXmlNode.getName());
		assertEquals("ping", hxXmlNode.getValue());
		
		hxXmlNode = XPathHxXml.wrapAttribute(xml, "aruga");
		assertEquals(Attribute, hxXmlNode.getType());
		assertEquals("aruga", hxXmlNode.getName());
		assertEquals("honk", hxXmlNode.getValue());
		
		caught = false;
		try {
			XPathHxXml.wrapAttribute(xml, "wooble");
		} catch (exception:XPathException) {
			caught = true;
		}
		assertTrue(caught);
		
		xml = null;
		caught = false;
		try {
			XPathHxXml.wrapNode(xml);
		} catch (exception:XPathException) {
			caught = true;
		}
		assertTrue(caught);
		
		caught = false;
		try {
			XPathHxXml.wrapAttribute(xml, "fuzz");
		} catch (exception:XPathException) {
			caught = true;
		}
		assertTrue(caught);
	}
	
	function testTextNodes () {
		var element = Xml.createElement("ihastexts");
		var text1 = Xml.createPCData("123&#94;456&#x3c;78");
		#if flash8
		var text2 = Xml.createPCData("abcdefg");
		#else true
		var text2 = Xml.createCData("abcdefg");
		#end
		var text3 = Xml.createPCData("poiuytr");
		var text4 = Xml.createPCData("lk&lt;&gt;&amp;&apos;&quot;jhg");
		#if flash8
		var text5 = Xml.createPCData("';;&amp;amp;llk&amp;gt;jf");
		var text6 = Xml.createPCData("vnsjd");
		#else true
		var text5 = Xml.createCData("';;&amp;llk&gt;jf");
		var text6 = Xml.createCData("vnsjd");
		#end
		var inbetween = Xml.createElement("lolols");
		var text7 = Xml.createPCData("9876");
		#if flash8
		var text8 = Xml.createPCData("8347");
		#else true
		var text8 = Xml.createCData("8347");
		#end
		element.addChild(text1);
		element.addChild(text2);
		element.addChild(text3);
		element.addChild(text4);
		element.addChild(text5);
		element.addChild(text6);
		element.addChild(inbetween);
		element.addChild(text7);
		element.addChild(text8);
		
		var string1 = (
			"123^456<78abcdefgpoiuytrlk<>&'" + '"' +
			"jhg';;&amp;llk&gt;jfvnsjd"
		);
		var string2 = "98768347";
		
		var hxXmlNode = XPathHxXml.wrapNode(text1);
		assertEquals(text1, hxXmlNode.getWrappedXml());
		assertEquals(string1, hxXmlNode.getValue());
		assertEquals(Text, hxXmlNode.getType());
		hxXmlNode = XPathHxXml.wrapNode(text2);
		assertEquals(text1, hxXmlNode.getWrappedXml());
		assertEquals(string1, hxXmlNode.getValue());
		assertEquals(Text, hxXmlNode.getType());
		hxXmlNode = XPathHxXml.wrapNode(text3);
		assertEquals(text1, hxXmlNode.getWrappedXml());
		assertEquals(string1, hxXmlNode.getValue());
		assertEquals(Text, hxXmlNode.getType());
		hxXmlNode = XPathHxXml.wrapNode(text4);
		assertEquals(text1, hxXmlNode.getWrappedXml());
		assertEquals(string1, hxXmlNode.getValue());
		assertEquals(Text, hxXmlNode.getType());
		hxXmlNode = XPathHxXml.wrapNode(text5);
		assertEquals(text1, hxXmlNode.getWrappedXml());
		assertEquals(string1, hxXmlNode.getValue());
		assertEquals(Text, hxXmlNode.getType());
		hxXmlNode = XPathHxXml.wrapNode(text6);
		assertEquals(text1, hxXmlNode.getWrappedXml());
		assertEquals(string1, hxXmlNode.getValue());
		assertEquals(Text, hxXmlNode.getType());
		hxXmlNode = XPathHxXml.wrapNode(inbetween);
		assertEquals(inbetween, hxXmlNode.getWrappedXml());
		assertEquals(Element, hxXmlNode.getType());
		hxXmlNode = XPathHxXml.wrapNode(text7);
		assertEquals(text7, hxXmlNode.getWrappedXml());
		assertEquals(string2, hxXmlNode.getValue());
		assertEquals(Text, hxXmlNode.getType());
		hxXmlNode = XPathHxXml.wrapNode(text8);
		assertEquals(text7, hxXmlNode.getWrappedXml());
		assertEquals(string2, hxXmlNode.getValue());
		assertEquals(Text, hxXmlNode.getType());
	}
	
	function testIs () {
		var wrappedE1 = XPathHxXml.wrapNode(e);
		var wrappedE2 = XPathHxXml.wrapNode(e);
		var wrappedEFoo1 = XPathHxXml.wrapAttribute(e, "foo");
		var wrappedEFoo2 = XPathHxXml.wrapAttribute(e, "foo");
		var wrappedEBar = XPathHxXml.wrapAttribute(e, "bar");
		var wrappedXml1 = XPathHxXml.wrapNode(xml);
		var wrappedXml2 = XPathHxXml.wrapNode(xml);
		
		assertTrue(wrappedE1.is(wrappedE1));
		assertTrue(wrappedE1.is(wrappedE2));
		assertFalse(wrappedE1.is(wrappedXml1));
		assertFalse(wrappedEFoo1.is(wrappedE1));
		assertTrue(wrappedEFoo1.is(wrappedEFoo1));
		assertTrue(wrappedEFoo1.is(wrappedEFoo2));
		assertFalse(wrappedEFoo1.is(wrappedEBar));
		assertFalse(wrappedEFoo1.is(wrappedXml1));
		assertTrue(wrappedEFoo2.is(wrappedEFoo1));
		assertTrue(wrappedE2.is(wrappedE1));
		assertFalse(wrappedE2.is(wrappedXml2));
		assertTrue(wrappedXml1.is(wrappedXml2));
		assertFalse(wrappedXml1.is(wrappedEFoo1));
	}
	
	function testGetAttributeIterator () {
		for (xmlNode in [
			XPathHxXml.wrapNode(a), XPathHxXml.wrapNode(text4)
		]) {
			var iterable = xmlNode.getAxisIterable(Axis.Attribute);
			for (iterator in [
				xmlNode.getAttributeIterator(),
				xmlNode.getAxisIterator(Axis.Attribute),
				iterable.iterator(), iterable.iterator()
			]) assertFalse(iterator.hasNext());
		}
		
		var xmlNode = XPathHxXml.wrapNode(e);
		var iterable = xmlNode.getAxisIterable(Axis.Attribute);
		for (iterator in [
			xmlNode.getAttributeIterator(),
			xmlNode.getAxisIterator(Axis.Attribute),
			iterable.iterator(), iterable.iterator()
		]) {
			var count = 0;
			var nameTaken;
			for (attr in iterator) {
				++count;
				assertEquals(Attribute, attr.getType());
				var name = attr.getName();
				assertTrue(name == "foo" || name == "bar");
				assertTrue(name != nameTaken);
				nameTaken = name;
				switch (name) {
					case "foo": assertEquals("123", attr.getValue());
					case "bar": assertEquals("456", attr.getValue());
				}
			}
			assertEquals(2, count);
		}
	}
	
	function testGetChildIterator () {
		var xmlNode = XPathHxXml.wrapNode(a);
		var iterable = xmlNode.getAxisIterable(Child);
		for (iterator in [
			xmlNode.getChildIterator(),
			xmlNode.getAxisIterator(Child),
			iterable.iterator(), iterable.iterator()
		]) {
			for (expectedNode in [ text1, b, text2, c, k, m ]) {
				assertTrue(iterator.hasNext());
				assertEquals(
					expectedNode,
					cast(iterator.next(), XPathHxXml).getWrappedXml()
				);
			}
			assertFalse(iterator.hasNext());
		}
		
		for (xmlNode in [
			XPathHxXml.wrapNode(j),
			XPathHxXml.wrapNode(text1),
			XPathHxXml.wrapAttribute(e, "foo")
		]) {
			iterable = xmlNode.getAxisIterable(Child);
			for (iterator in [
				xmlNode.getChildIterator(),
				xmlNode.getAxisIterator(Child),
				iterable.iterator(), iterable.iterator()
			]) assertFalse(iterator.hasNext());
		}
	}
	
	function testGetFollowingIterator () {
		var xmlNode = XPathHxXml.wrapNode(e);
		var iterable = xmlNode.getAxisIterable(Following);
		for (iterator in [
			xmlNode.getFollowingIterator(),
			xmlNode.getAxisIterator(Following),
			iterable.iterator(), iterable.iterator()
		]) {
			for (expectedNode in [ text7, f, g, h, i, text8, j, k, l, m ]) {
				assertTrue(iterator.hasNext());
				assertEquals(
					expectedNode,
					cast(iterator.next(), XPathHxXml).getWrappedXml()
				);
			}
			assertFalse(iterator.hasNext());
		}
		
		xmlNode = XPathHxXml.wrapNode(xml);
		iterable = xmlNode.getAxisIterable(Following);
		for (iterator in [
			xmlNode.getFollowingIterator(),
			xmlNode.getAxisIterator(Following),
			iterable.iterator(), iterable.iterator()
		]) {
			for (expectedNode in [
				a, text1, b, text2, c, text3, d, text4, e,
				text7, f, g, h, i, text8, j, k, l, m
			]) {
				assertTrue(iterator.hasNext());
				assertEquals(
					expectedNode,
					cast(iterator.next(), XPathHxXml).getWrappedXml()
				);
			}
			assertFalse(iterator.hasNext());
		}
		
		xmlNode = XPathHxXml.wrapAttribute(e, "foo");
		iterable = xmlNode.getAxisIterable(Following);
		for (iterator in [
			xmlNode.getFollowingIterator(),
			xmlNode.getAxisIterator(Following),
			iterable.iterator(), iterable.iterator()
		]) assertFalse(iterator.hasNext());
	}
	
	function testGetFollowingSiblingIterator () {
		var xmlNode = XPathHxXml.wrapNode(e);
		var iterable = xmlNode.getAxisIterable(FollowingSibling);
		for (iterator in [
			xmlNode.getFollowingSiblingIterator(),
			xmlNode.getAxisIterator(FollowingSibling),
			iterable.iterator(), iterable.iterator()
		]) {
			for (expectedNode in [ h, j ]) {
				assertTrue(iterator.hasNext());
				assertEquals(
					expectedNode,
					cast(iterator.next(), XPathHxXml).getWrappedXml()
				);
			}
			assertFalse(iterator.hasNext());
		}
		
		var xmlNode = XPathHxXml.wrapNode(b);
		iterable = xmlNode.getAxisIterable(FollowingSibling);
		for (iterator in [
			xmlNode.getFollowingSiblingIterator(),
			xmlNode.getAxisIterator(FollowingSibling),
			iterable.iterator(), iterable.iterator()
		]) {
			for (expectedNode in [ text2, c, k, m ]) {
				assertTrue(iterator.hasNext());
				assertEquals(
					expectedNode,
					cast(iterator.next(), XPathHxXml).getWrappedXml()
				);
			}
			assertFalse(iterator.hasNext());
		}
		
		var xmlNode = XPathHxXml.wrapNode(i);
		iterable = xmlNode.getAxisIterable(FollowingSibling);
		for (iterator in [
			xmlNode.getFollowingSiblingIterator(),
			xmlNode.getAxisIterator(FollowingSibling),
			iterable.iterator(), iterable.iterator()
		]) {
			assertTrue(iterator.hasNext());
			assertEquals(
				text8,
				cast(iterator.next(), XPathHxXml).getWrappedXml()
			);
			assertFalse(iterator.hasNext());
		}
		
		for (xmlNode in [
			XPathHxXml.wrapNode(xml), XPathHxXml.wrapNode(a),
			XPathHxXml.wrapNode(l)
		]) {
			iterable = xmlNode.getAxisIterable(FollowingSibling);
			for (iterator in [
				xmlNode.getFollowingSiblingIterator(),
				xmlNode.getAxisIterator(FollowingSibling),
				iterable.iterator(), iterable.iterator()
			]) {
				assertFalse(iterator.hasNext());
			}
		}
	}
	
	function testGetNamespaceIterator () {
		var xmlNode = XPathHxXml.wrapNode(a);
		var iterable = xmlNode.getAxisIterable(Axis.Namespace);
		for (iterator in [
			xmlNode.getNamespaceIterator(),
			xmlNode.getAxisIterator(Axis.Namespace),
			iterable.iterator(), iterable.iterator()
		]) {
			// namespaces not supported by haXe Xml
			assertFalse(iterator.hasNext());
		}
	}
	
	function testGetParent () {
		var xmlNode:XPathXml = XPathHxXml.wrapNode(text9);
		for (expectedNode in [ text8, h, c, a, xml ]) {
			assertEquals(expectedNode, cast(xmlNode, XPathHxXml).getWrappedXml());
			xmlNode = xmlNode.getParent();
		}
		assertEquals(null, xmlNode);
		
		xmlNode = XPathHxXml.wrapAttribute(i, "blib");
		for (expectedNode in [ i, h, c, a, xml ]) {
			xmlNode = xmlNode.getParent();
			assertEquals(expectedNode, cast(xmlNode, XPathHxXml).getWrappedXml());
		}
		assertEquals(null, xmlNode.getParent());
	}
	
	function testGetPrecedingIterator () {
		var xmlNode = XPathHxXml.wrapNode(h);
		var iterable = xmlNode.getAxisIterable(Preceding);
		for (iterator in [
			xmlNode.getPrecedingIterator(),
			xmlNode.getAxisIterator(Preceding),
			iterable.iterator(), iterable.iterator()
		]) {
			for (expectedNode in [
				g, f, text7, e, text4, d, text3, c, text2, b, text1, a, xml
			]) {
				assertTrue(iterator.hasNext());
				assertEquals(
					expectedNode,
					cast(iterator.next(), XPathHxXml).getWrappedXml()
				);
			}
			assertFalse(iterator.hasNext());
		}
		
		xmlNode = XPathHxXml.wrapNode(d);
		iterable = xmlNode.getAxisIterable(Preceding);
		for (iterator in [
			xmlNode.getPrecedingIterator(),
			xmlNode.getAxisIterator(Preceding),
			iterable.iterator(), iterable.iterator()
		]) {
			for (expectedNode in [
				text3, c, text2, b, text1, a, xml
			]) {
				assertTrue(iterator.hasNext());
				assertEquals(
					expectedNode,
					cast(iterator.next(), XPathHxXml).getWrappedXml()
				);
			}
			assertFalse(iterator.hasNext());
		}
	}
	
	function testGetPrecedingSiblingIterator () {
		var xmlNode = XPathHxXml.wrapNode(h);
		var iterable = xmlNode.getAxisIterable(PrecedingSibling);
		for (iterator in [
			xmlNode.getPrecedingSiblingIterator(),
			xmlNode.getAxisIterator(PrecedingSibling),
			iterable.iterator(), iterable.iterator()
		]) {
			for (expectedNode in [ e, text4, d, text3 ]) {
				assertTrue(iterator.hasNext());
				assertEquals(
					expectedNode,
					cast(iterator.next(), XPathHxXml).getWrappedXml()
				);
			}
			assertFalse(iterator.hasNext());
		}
		
		for (xmlNode in [ XPathHxXml.wrapNode(a), XPathHxXml.wrapNode(xml) ]) {
			iterable = xmlNode.getAxisIterable(PrecedingSibling);
			for (iterator in [
				xmlNode.getPrecedingSiblingIterator(),
				xmlNode.getAxisIterator(PrecedingSibling),
				iterable.iterator(), iterable.iterator()
			]) {
				assertFalse(iterator.hasNext());
			}
		}
	}
	
}
