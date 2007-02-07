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


package xpath.unit.expression;
import haxe.unit.TestCase;
import dcxml.Xml;
import xpath.expression.AxisStep;
import xpath.context.Context;
import xpath.context.Environment;
import xpath.context.DynamicEnvironment;
import xpath.token.AxisToken;
import xpath.type.XPathValue;
import xpath.type.XPathNodeSet;


class TestAxisStep extends TestCase {
	
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
	
	private var environment:Environment;
	
	
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
			
		environment = new DynamicEnvironment();
	}
	
	private function testAncestor() {
		var axisStep:AxisStep = new AxisStep(Ancestor);

		var result:XPathValue = axisStep.evaluate(new Context(b, 1, 1, environment));
		var nodes:Array<Xml> = cast(result, XPathNodeSet).getNodes();
		assertEquals(2, nodes.length);
		assertEquals(a, nodes[0]);
		assertEquals(xml, nodes[1]);
		
		result = axisStep.evaluate(new Context(g, 1, 1, environment));
		nodes = cast(result, XPathNodeSet).getNodes();
		assertEquals(4, nodes.length);
		assertEquals(e, nodes[0]);
		assertEquals(c, nodes[1]);
		assertEquals(a, nodes[2]);
		assertEquals(xml, nodes[3]);
	}
	
	private function testAncestorOrSelf () {
		var axisStep:AxisStep = new AxisStep(AncestorOrSelf);

		var result:XPathNodeSet = axisStep.evaluate(new Context(b, 1, 1, environment));
		var nodes:Array<Xml> = cast(result, XPathNodeSet).getNodes();
		assertEquals(3, nodes.length);
		assertEquals(b, nodes[0]);
		assertEquals(a, nodes[1]);
		assertEquals(xml, nodes[2]);
		
		result = axisStep.evaluate(new Context(g, 1, 1, environment));
		nodes = cast(result, XPathNodeSet).getNodes();
		assertEquals(5, nodes.length);
		assertEquals(g, nodes[0]);
		assertEquals(e, nodes[1]);
		assertEquals(c, nodes[2]);
		assertEquals(a, nodes[3]);
		assertEquals(xml, nodes[4]);
	}
	
	private function testAttribute () {
		var axisStep:AxisStep = new AxisStep(AxisEnum.Attribute);

		var result:XPathNodeSet = axisStep.evaluate(new Context(e, 1, 1, environment));
		var nodes:Array<Xml> = cast(result, XPathNodeSet).getNodes();
		assertEquals(2, nodes.length);

		var foo:Xml = e.getAttribute("foo");
		var bar:Xml = e.getAttribute("bar");
		var foundFoo:Bool = false;
		var foundBar:Bool = false;
		var foundSomethingElse:Bool = false;
		for (node in nodes) {
			if (node == foo) foundFoo = true;
			else if (node == bar) foundBar = true;
			else foundSomethingElse = true;
		}
		assertTrue(foundFoo);
		assertTrue(foundBar);
		assertFalse(foundSomethingElse);
		
		result = axisStep.evaluate(new Context(i, 1, 1, environment));
		nodes = cast(result, XPathNodeSet).getNodes();
		assertEquals(2, nodes.length);
		
		var blib:Xml = i.getAttribute("blib");
		var blob:Xml = i.getAttribute("blob");
		var foundBlib:Bool = false;
		var foundBlob:Bool = false;
		foundSomethingElse = false;
		for (node in nodes) {
			if (node == blib) foundBlib = true;
			else if (node == blob) foundBlob = true;
			else foundSomethingElse = true;
		}
		assertTrue(foundBlib);
		assertTrue(foundBlob);
		assertFalse(foundSomethingElse);
		
		result = axisStep.evaluate(new Context(g, 1, 1, environment));
		nodes = cast(result, XPathNodeSet).getNodes();
		assertEquals(0, nodes.length);
	}
	
	private function testChild () {
		var axisStep:AxisStep = new AxisStep(Child);
		
		var result:XPathNodeSet = axisStep.evaluate(new Context(xml, 1, 1, environment));
		var nodes:Array<Xml> = cast(result, XPathNodeSet).getNodes();
		assertEquals(1, nodes.length);
		assertEquals(a, nodes[0]);
		
		result = axisStep.evaluate(new Context(a, 1, 1, environment));
		nodes = cast(result, XPathNodeSet).getNodes();
		assertEquals(4, nodes.length);
		assertEquals(b, nodes[0]);
		assertEquals(c, nodes[1]);
		assertEquals(k, nodes[2]);
		assertEquals(m, nodes[3]);
		
		result = axisStep.evaluate(new Context(g, 1, 1, environment));
		nodes = cast(result, XPathNodeSet).getNodes();
		assertEquals(0, nodes.length);
	}
	
	private function testDescendant () {
		var axisStep:AxisStep = new AxisStep(Descendant);
		
		var result:XPathNodeSet = axisStep.evaluate(new Context(c, 1, 1, environment));
		var nodes:Array<Xml> = cast(result, XPathNodeSet).getNodes();
		assertEquals(7, nodes.length);
		assertEquals(d, nodes[0]);
		assertEquals(e, nodes[1]);
		assertEquals(f, nodes[2]);
		assertEquals(g, nodes[3]);
		assertEquals(h, nodes[4]);
		assertEquals(i, nodes[5]);
		assertEquals(j, nodes[6]);
		
		result = axisStep.evaluate(new Context(xml, 1, 1, environment));
		nodes = cast(result, XPathNodeSet).getNodes();
		assertEquals(13, nodes.length);
		assertEquals(a, nodes[0]);
		assertEquals(b, nodes[1]);
		assertEquals(c, nodes[2]);
		assertEquals(d, nodes[3]);
		assertEquals(e, nodes[4]);
		assertEquals(f, nodes[5]);
		assertEquals(g, nodes[6]);
		assertEquals(h, nodes[7]);
		assertEquals(i, nodes[8]);
		assertEquals(j, nodes[9]);
		assertEquals(k, nodes[10]);
		assertEquals(l, nodes[11]);
		assertEquals(m, nodes[12]);
		
		result = axisStep.evaluate(new Context(l, 1, 1, environment));
		nodes = cast(result, XPathNodeSet).getNodes();
		assertEquals(0, nodes.length);
	}
	
	private function testDescendantOrSelf () {
		var axisStep:AxisStep = new AxisStep(DescendantOrSelf);
		
		var result:XPathNodeSet = axisStep.evaluate(new Context(c, 1, 1, environment));
		var nodes:Array<Xml> = cast(result, XPathNodeSet).getNodes();
		assertEquals(8, nodes.length);
		assertEquals(c, nodes[0]);
		assertEquals(d, nodes[1]);
		assertEquals(e, nodes[2]);
		assertEquals(f, nodes[3]);
		assertEquals(g, nodes[4]);
		assertEquals(h, nodes[5]);
		assertEquals(i, nodes[6]);
		assertEquals(j, nodes[7]);
		
		result = axisStep.evaluate(new Context(xml, 1, 1, environment));
		nodes = cast(result, XPathNodeSet).getNodes();
		assertEquals(14, nodes.length);
		assertEquals(xml, nodes[0]);
		assertEquals(a, nodes[1]);
		assertEquals(b, nodes[2]);
		assertEquals(c, nodes[3]);
		assertEquals(d, nodes[4]);
		assertEquals(e, nodes[5]);
		assertEquals(f, nodes[6]);
		assertEquals(g, nodes[7]);
		assertEquals(h, nodes[8]);
		assertEquals(i, nodes[9]);
		assertEquals(j, nodes[10]);
		assertEquals(k, nodes[11]);
		assertEquals(l, nodes[12]);
		assertEquals(m, nodes[13]);
		
		result = axisStep.evaluate(new Context(l, 1, 1, environment));
		nodes = cast(result, XPathNodeSet).getNodes();
		assertEquals(1, nodes.length);
		assertEquals(l, nodes[0]);
	}
	
	private function testFollowing () {
		var axisStep:AxisStep = new AxisStep(Following);
		
		var result:XPathNodeSet = axisStep.evaluate(new Context(xml, 1, 1, environment));
		var nodes:Array<Xml> = cast(result, XPathNodeSet).getNodes();
		assertEquals(13, nodes.length);
		assertEquals(a, nodes[0]);
		assertEquals(b, nodes[1]);
		assertEquals(c, nodes[2]);
		assertEquals(d, nodes[3]);
		assertEquals(e, nodes[4]);
		assertEquals(f, nodes[5]);
		assertEquals(g, nodes[6]);
		assertEquals(h, nodes[7]);
		assertEquals(i, nodes[8]);
		assertEquals(j, nodes[9]);
		assertEquals(k, nodes[10]);
		assertEquals(l, nodes[11]);
		assertEquals(m, nodes[12]);
		
		result = axisStep.evaluate(new Context(i, 1, 1, environment));
		nodes = cast(result, XPathNodeSet).getNodes();
		assertEquals(4, nodes.length);
		assertEquals(j, nodes[0]);
		assertEquals(k, nodes[1]);
		assertEquals(l, nodes[2]);
		assertEquals(m, nodes[3]);
		
		result = axisStep.evaluate(new Context(m, 1, 1, environment));
		nodes = cast(result, XPathNodeSet).getNodes();
		assertEquals(0, nodes.length);
	}
	
	private function testFollowingSibling () {
		var axisStep:AxisStep = new AxisStep(FollowingSibling);
		
		var result:XPathNodeSet = axisStep.evaluate(new Context(xml, 1, 1, environment));
		var nodes:Array<Xml> = cast(result, XPathNodeSet).getNodes();
		assertEquals(0, nodes.length);
		
		result = axisStep.evaluate(new Context(e, 1, 1, environment));
		nodes = cast(result, XPathNodeSet).getNodes();
		assertEquals(2, nodes.length);
		assertEquals(h, nodes[0]);
		assertEquals(j, nodes[1]);
	}
	
	// TODO: testNamespace
	
	private function testParent () {
		var axisStep:AxisStep = new AxisStep(Parent);
		
		var result:XPathNodeSet = axisStep.evaluate(new Context(xml, 1, 1, environment));
		var nodes:Array<Xml> = cast(result, XPathNodeSet).getNodes();
		assertEquals(0, nodes.length);
		
		result = axisStep.evaluate(new Context(a, 1, 1, environment));
		var nodes:Array<Xml> = cast(result, XPathNodeSet).getNodes();
		assertEquals(1, nodes.length);
		assertEquals(xml, nodes[0]);
		
		result = axisStep.evaluate(new Context(l, 1, 1, environment));
		var nodes:Array<Xml> = cast(result, XPathNodeSet).getNodes();
		assertEquals(1, nodes.length);
		assertEquals(k, nodes[0]);
	}
	
	private function testPreceding () {
		var axisStep:AxisStep = new AxisStep(Preceding);
		
		var result:XPathNodeSet = axisStep.evaluate(new Context(xml, 1, 1, environment));
		var nodes:Array<Xml> = cast(result, XPathNodeSet).getNodes();
		assertEquals(0, nodes.length);
		
		result = axisStep.evaluate(new Context(i, 1, 1, environment));
		nodes = cast(result, XPathNodeSet).getNodes();
		assertEquals(9, nodes.length);
		assertEquals(h, nodes[0]);
		assertEquals(g, nodes[1]);
		assertEquals(f, nodes[2]);
		assertEquals(e, nodes[3]);
		assertEquals(d, nodes[4]);
		assertEquals(c, nodes[5]);
		assertEquals(b, nodes[6]);
		assertEquals(a, nodes[7]);
		assertEquals(xml, nodes[8]);
		
		result = axisStep.evaluate(new Context(m, 1, 1, environment));
		nodes = cast(result, XPathNodeSet).getNodes();
		assertEquals(13, nodes.length);
		assertEquals(l, nodes[0]);
		assertEquals(k, nodes[1]);
		assertEquals(j, nodes[2]);
		assertEquals(i, nodes[3]);
		assertEquals(h, nodes[4]);
		assertEquals(g, nodes[5]);
		assertEquals(f, nodes[6]);
		assertEquals(e, nodes[7]);
		assertEquals(d, nodes[8]);
		assertEquals(c, nodes[9]);
		assertEquals(b, nodes[10]);
		assertEquals(a, nodes[11]);
		assertEquals(xml, nodes[12]);
	}
	
	private function testPrecedingSibling () {
		var axisStep:AxisStep = new AxisStep(PrecedingSibling);
		
		var result:XPathNodeSet = axisStep.evaluate(new Context(xml, 1, 1, environment));
		var nodes:Array<Xml> = cast(result, XPathNodeSet).getNodes();
		assertEquals(0, nodes.length);
		
		result = axisStep.evaluate(new Context(h, 1, 1, environment));
		nodes = cast(result, XPathNodeSet).getNodes();
		assertEquals(2, nodes.length);
		assertEquals(e, nodes[0]);
		assertEquals(d, nodes[1]);
	}
	
	private function testSelf () {
		var axisStep:AxisStep = new AxisStep(Self);
		
		for (node in [xml, a, b, c, d, e, f, g, h, i, j, k, l, m]) {
			var result:XPathNodeSet = axisStep.evaluate(new Context(node, 1, 1, environment));
			var nodes:Array<Xml> = cast(result, XPathNodeSet).getNodes();
			assertEquals(1, nodes.length);
			assertEquals(node, nodes[0]);
		}
	}	
	
}