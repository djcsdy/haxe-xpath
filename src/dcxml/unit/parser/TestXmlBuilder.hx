/* dcxml by Daniel J. Cassidy <mail@danielcassidy.me.uk>
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


package dcxml.unit.parser;
import haxe.unit.TestCase;
import dcxml.Xml;
import dcxml.XmlInternalException;
import dcxml.parser.XmlBuilder;


class TestXmlBuilder extends TestCase {
	
	private function testSimple1 () {
		var builder:XmlBuilder = new XmlBuilder();
		builder.startDocument();
		builder.startElement("abc", new Hash<String>());
		builder.endElement("abc");
		builder.endDocument();
		
		var xml:Xml = builder.getXml();
		assertEquals(Document, xml.type);
		var child:Xml = xml.getChild();
		assertEquals(Element, child.type);
		assertEquals("abc", child.name);
		child = child.getSibling(1);
		assertEquals(null, child);
	}
	
	private function testSimple2 () {
		var builder:XmlBuilder = new XmlBuilder();
		builder.startDocument();
		builder.characters("\n");
		builder.startElement("abc", new Hash<String>());
		builder.characters("   ");
		builder.endElement("abc");
		builder.characters("\n");
		builder.endDocument();
		
		var xml:Xml = builder.getXml();
		assertEquals(Document, xml.type);
		var child:Xml = xml.getChild();
		assertEquals(Text, child.type);
		assertEquals("\n", child.text);
		child = child.getSibling(1);
		assertEquals(Element, child.type);
		assertEquals("abc", child.name);
		var grandChild:Xml = child.getChild();
		assertEquals(Text, grandChild.type);
		assertEquals("   ", grandChild.text);
		assertEquals(null, grandChild.getSibling(1));
		child = child.getSibling(1);
		assertEquals(Text, child.type);
		assertEquals("\n", child.text);
		assertEquals(null, child.getSibling(1));
	}
	
	private function testComplex () {
		var builder:XmlBuilder = new XmlBuilder();
		
		/* <a>
		 *     <b/>
		 *     <c name="foo"/>
		 *     <d name="bar">
		 *         <e name="foo"/>
		 *     </d>
		 * </a> */
		builder.startDocument();
		builder.startElement("a", new Hash<String>());
		builder.characters("\n\t");
		builder.startElement("b", new Hash<String>());
		builder.endElement("b");
		builder.characters("\n\t");
		var attributes1:Hash<String> = new Hash<String>();
		attributes1.set("name", "foo");
		builder.startElement("c", attributes1);
		builder.endElement("c");
		builder.characters("\n\t");
		var attributes2:Hash<String> = new Hash<String>();
		attributes2.set("name", "bar");
		builder.startElement("d", attributes2);
		builder.characters("\n\t\t");
		builder.startElement("e", attributes1);
		builder.endElement("e");
		builder.characters("\n\t");
		builder.endElement("d");
		builder.characters("\n");
		builder.endElement("a");
		builder.endDocument();
		
		var xml:Xml = builder.getXml();
		var a:Xml = xml.getChild();
		var aTxt1:Xml = a.getChild();
		var b:Xml = aTxt1.getSibling(1);
		var aTxt2:Xml = b.getSibling(1);
		var c:Xml = aTxt2.getSibling(1);
		var aTxt3:Xml = c.getSibling(1);
		var d:Xml = aTxt3.getSibling(1);
		var dTxt1:Xml = d.getChild();
		var e:Xml = dTxt1.getSibling(1);
		var dTxt2:Xml = e.getSibling(1);
		var aTxt4:Xml = d.getSibling(1);
		
		assertEquals(Document, xml.type);
		assertEquals(Element, a.type);
		assertEquals(Element, b.type);
		assertEquals(Element, c.type);
		assertEquals(Element, d.type);
		assertEquals(Element, e.type);
		assertEquals(Text, aTxt1.type);
		assertEquals(Text, aTxt2.type);
		assertEquals(Text, aTxt3.type);
		assertEquals(Text, aTxt4.type);
		assertEquals(Text, dTxt1.type);
		assertEquals(Text, dTxt2.type);
		
		assertEquals(null, xml.getSibling(-1));
		assertEquals(null, xml.getSibling(1));
		assertEquals(null, a.getSibling(-1));
		assertEquals(null, a.getSibling(1));
		assertEquals(null, aTxt1.getSibling(-1));
		assertEquals(null, aTxt4.getSibling(1));
		assertEquals(null, dTxt1.getSibling(-1));
		assertEquals(null, dTxt2.getSibling(1));
		
		assertEquals("a", a.name);
		assertEquals("b", b.name);
		assertEquals("c", c.name);
		assertEquals("d", d.name);
		assertEquals("e", e.name);
		
		assertEquals("\n\t", aTxt1.text);
		assertEquals("\n\t", aTxt2.text);
		assertEquals("\n\t", aTxt3.text);
		assertEquals("\n", aTxt4.text);
		assertEquals("\n\t\t", dTxt1.text);
		assertEquals("\n\t", dTxt2.text);
	}
	
	private function testMissingStart () {
		var builder:XmlBuilder = new XmlBuilder();
		
		var caught:Bool = false;
		try {
			builder.startElement("fgsg", new Hash<String>());
		} catch (e:XmlInternalException) {
			caught = true;
		}
		assertTrue(caught);
		
		caught = false;
		try {
			builder.characters("pfosgjs");
		} catch (e:XmlInternalException) {
			caught = true;
		}
		assertTrue(caught);
		
		caught = false;
		try {
			builder.comment("sgkjh");
		} catch (e:XmlInternalException) {
			caught = true;
		}
		assertTrue(caught);
		
		caught = false;
		try {
			builder.processingInstruction("rgsjog", "jp;fp");
		} catch (e:XmlInternalException) {
			caught = true;
		}
		assertTrue(caught);
	}
		
}