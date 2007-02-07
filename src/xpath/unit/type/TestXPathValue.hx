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


package xpath.unit.type;
import haxe.unit.TestCase;
import dcxml.Xml;
import xpath.type.XPathValue;
import xpath.type.XPathBoolean;
import xpath.type.XPathNumber;
import xpath.type.XPathString;
import xpath.type.XPathNodeSet;


class TestXPathValue extends TestCase {
	
	/* <a>
	 *     <b/>
	 *     <c>
	 *         <d/>
	 *         <e foo="123" bar="456">
	 *             <f/>
	 *             <g/>
	 *         </e>
	 *         <h>
	 *             <i blib="abc" blob="def" />
	 *         </h>
	 *         <j/>
	 *     </c>
	 *     <k>
	 *         <l/>
	 *     </k>
	 *     <m/>
	 * </a>
	 */
	private var xml:Xml;
	private var a:Xml;
	private var b:Xml;
	private var c:Xml;
	private var d:Xml;
	private var e:Xml;
	private var f:Xml;
	private var g:Xml;
	private var h:Xml;
	private var i:Xml;
	private var j:Xml;
	private var k:Xml;
	private var l:Xml;
	private var m:Xml;
	
	
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
		
		e.setAttributeValue("foo", "123");
		e.setAttributeValue("bar", "456");
		i.setAttributeValue("blib", "abc");
		i.setAttributeValue("blob", "def");
		
		xml.addChild(a);
		a.addChild(b);
		a.addChild(c);
		a.addChild(k);
		a.addChild(m);
		c.addChild(d);
		c.addChild(e);
		c.addChild(h);
		c.addChild(j);
		e.addChild(f);
		e.addChild(g);
		h.addChild(i);
		k.addChild(l);
	}
	
	private function testEquals () {
		var nodes:Array<Xml> = [ e.getAttribute("foo"), e.getAttribute("bar") ];
		var nodeSet:XPathNodeSet = new XPathNodeSet(nodes);
		var string1:XPathString = new XPathString("123");
		var string2:XPathString = new XPathString("456");
		var string3:XPathString = new XPathString("789");
		var number:XPathNumber = new XPathNumber(123);
		
		var result:XPathBoolean = nodeSet.equals(string1);
		assertTrue(result.getBool());
		
		var result:XPathBoolean = nodeSet.equals(string2);
		assertTrue(result.getBool());

		var result:XPathBoolean = nodeSet.equals(string3);
		assertFalse(result.getBool());

		var result:XPathBoolean = nodeSet.equals(number);
		assertTrue(result.getBool());
	}
	
}