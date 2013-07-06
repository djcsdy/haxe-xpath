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
import Haxe.unit.TestCase;
import xpath.context.FakeContext;
import xpath.value.XPathNodeSet;
import xpath.xml.XPathXml;
import xpath.xml.XPathHxXml;
import xpath.Axis;


class AxisStepTest extends TestCase {
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
		
		e.set("foo", "123");
		e.set("bar", "456");
		i.set("blib", "abc");
		i.set("blob", "def");
		
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
	
	function testAncestor() {
		var axisStep = new AxisStep(Axis.Ancestor);

		var result = axisStep.evaluate(new FakeContext(XPathHxXml.wrapNode(b)));
		var nodes = Lambda.array(cast(result, XPathNodeSet).getNodes());
		assertEquals(2, nodes.length);
		assertEquals(a, cast(nodes[0], XPathHxXml).getWrappedXml());
		assertEquals(xml, cast(nodes[1], XPathHxXml).getWrappedXml());
		
		result = axisStep.evaluate(new FakeContext(XPathHxXml.wrapNode(g), 1, 1));
		nodes = Lambda.array(cast(result, XPathNodeSet).getNodes());
		assertEquals(4, nodes.length);
		assertEquals(e, cast(nodes[0], XPathHxXml).getWrappedXml());
		assertEquals(c, cast(nodes[1], XPathHxXml).getWrappedXml());
		assertEquals(a, cast(nodes[2], XPathHxXml).getWrappedXml());
		assertEquals(xml, cast(nodes[3], XPathHxXml).getWrappedXml());
	}
	
	function testAncestorOrSelf () {
		var axisStep = new AxisStep(Axis.AncestorOrSelf);
		
		var result = axisStep.evaluate(new FakeContext(XPathHxXml.wrapNode(b)));
		var nodes = Lambda.array(cast(result, XPathNodeSet).getNodes());
		assertEquals(3, nodes.length);
		assertEquals(b, cast(nodes[0], XPathHxXml).getWrappedXml());
		assertEquals(a, cast(nodes[1], XPathHxXml).getWrappedXml());
		assertEquals(xml, cast(nodes[2], XPathHxXml).getWrappedXml());
		
		result = axisStep.evaluate(new FakeContext(XPathHxXml.wrapNode(g)));
		nodes = Lambda.array(cast(result, XPathNodeSet).getNodes());
		assertEquals(5, nodes.length);
		assertEquals(g, cast(nodes[0], XPathHxXml).getWrappedXml());
		assertEquals(e, cast(nodes[1], XPathHxXml).getWrappedXml());
		assertEquals(c, cast(nodes[2], XPathHxXml).getWrappedXml());
		assertEquals(a, cast(nodes[3], XPathHxXml).getWrappedXml());
		assertEquals(xml, cast(nodes[4], XPathHxXml).getWrappedXml());
	}
	
	function testAttribute () {
		var axisStep = new AxisStep(Axis.Attribute);
		
		var result = axisStep.evaluate(new FakeContext(XPathHxXml.wrapNode(e)));
		var nodes = cast(result, XPathNodeSet).getNodes();
		
		var fooCount = 0;
		var barCount = 0;
		var otherCount = 0;
		for (node in nodes) {
			switch (node.getName()) {
				case "foo":
				assertEquals("123", node.getValue());
				++fooCount;
				
				case "bar":
				assertEquals("456", node.getValue());
				++barCount;
				
				default:
				++otherCount;
			}
		}
		
		assertEquals(1, fooCount);
		assertEquals(1, barCount);
		assertEquals(0, otherCount);
		
		result = axisStep.evaluate(new FakeContext(XPathHxXml.wrapNode(i)));
		nodes = cast(result, XPathNodeSet).getNodes();
		
		var blibCount = 0;
		var blobCount = 0;
		otherCount = 0;
		
		for (node in nodes) {
			switch(node.getName()) {
				case "blib":
				assertEquals("abc", node.getValue());
				++blibCount;
				
				case "blob":
				assertEquals("def", node.getValue());
				++blobCount;
				
				default:
				++otherCount;
			}
		}
		
		assertEquals(1, blibCount);
		assertEquals(1, blobCount);
		assertEquals(0, otherCount);
	}
	
	function testChild () {
		var axisStep = new AxisStep(Axis.Child);
		
		var result = axisStep.evaluate(new FakeContext(XPathHxXml.wrapNode(xml)));
		var nodes = Lambda.array(cast(result, XPathNodeSet).getNodes());
		assertEquals(1, nodes.length);
		assertEquals(a, cast(nodes[0], XPathHxXml).getWrappedXml());
		
		result = axisStep.evaluate(new FakeContext(XPathHxXml.wrapNode(a)));
		nodes = Lambda.array(cast(result, XPathNodeSet).getNodes());
		assertEquals(4, nodes.length);
		assertEquals(b, cast(nodes[0], XPathHxXml).getWrappedXml());
		assertEquals(c, cast(nodes[1], XPathHxXml).getWrappedXml());
		assertEquals(k, cast(nodes[2], XPathHxXml).getWrappedXml());
		assertEquals(m, cast(nodes[3], XPathHxXml).getWrappedXml());
		
		result = axisStep.evaluate(new FakeContext(XPathHxXml.wrapNode(g)));
		nodes = Lambda.array(cast(result, XPathNodeSet).getNodes());
		assertEquals(0, nodes.length);
	}
	
	function testDescendant () {
		var axisStep = new AxisStep(Axis.Descendant);
		
		var result = axisStep.evaluate(new FakeContext(XPathHxXml.wrapNode(c)));
		var nodes = Lambda.array(cast(result, XPathNodeSet).getNodes());
		assertEquals(7, nodes.length);
		assertEquals(d, cast(nodes[0], XPathHxXml).getWrappedXml());
		assertEquals(e, cast(nodes[1], XPathHxXml).getWrappedXml());
		assertEquals(f, cast(nodes[2], XPathHxXml).getWrappedXml());
		assertEquals(g, cast(nodes[3], XPathHxXml).getWrappedXml());
		assertEquals(h, cast(nodes[4], XPathHxXml).getWrappedXml());
		assertEquals(i, cast(nodes[5], XPathHxXml).getWrappedXml());
		assertEquals(j, cast(nodes[6], XPathHxXml).getWrappedXml());
		
		result = axisStep.evaluate(new FakeContext(XPathHxXml.wrapNode(xml)));
		nodes = Lambda.array(cast(result, XPathNodeSet).getNodes());
		assertEquals(13, nodes.length);
		assertEquals(a, cast(nodes[0], XPathHxXml).getWrappedXml());
		assertEquals(b, cast(nodes[1], XPathHxXml).getWrappedXml());
		assertEquals(c, cast(nodes[2], XPathHxXml).getWrappedXml());
		assertEquals(d, cast(nodes[3], XPathHxXml).getWrappedXml());
		assertEquals(e, cast(nodes[4], XPathHxXml).getWrappedXml());
		assertEquals(f, cast(nodes[5], XPathHxXml).getWrappedXml());
		assertEquals(g, cast(nodes[6], XPathHxXml).getWrappedXml());
		assertEquals(h, cast(nodes[7], XPathHxXml).getWrappedXml());
		assertEquals(i, cast(nodes[8], XPathHxXml).getWrappedXml());
		assertEquals(j, cast(nodes[9], XPathHxXml).getWrappedXml());
		assertEquals(k, cast(nodes[10], XPathHxXml).getWrappedXml());
		assertEquals(l, cast(nodes[11], XPathHxXml).getWrappedXml());
		assertEquals(m, cast(nodes[12], XPathHxXml).getWrappedXml());
		
		result = axisStep.evaluate(new FakeContext(XPathHxXml.wrapNode(l)));
		nodes = Lambda.array(cast(result, XPathNodeSet).getNodes());
		assertEquals(0, nodes.length);
	}
	
	function testDescendantOrSelf () {
		var axisStep = new AxisStep(Axis.DescendantOrSelf);
		
		var result = axisStep.evaluate(new FakeContext(XPathHxXml.wrapNode(c)));
		var nodes = Lambda.array(cast(result, XPathNodeSet).getNodes());
		assertEquals(8, nodes.length);
		assertEquals(c, cast(nodes[0], XPathHxXml).getWrappedXml());
		assertEquals(d, cast(nodes[1], XPathHxXml).getWrappedXml());
		assertEquals(e, cast(nodes[2], XPathHxXml).getWrappedXml());
		assertEquals(f, cast(nodes[3], XPathHxXml).getWrappedXml());
		assertEquals(g, cast(nodes[4], XPathHxXml).getWrappedXml());
		assertEquals(h, cast(nodes[5], XPathHxXml).getWrappedXml());
		assertEquals(i, cast(nodes[6], XPathHxXml).getWrappedXml());
		assertEquals(j, cast(nodes[7], XPathHxXml).getWrappedXml());
		
		result = axisStep.evaluate(new FakeContext(XPathHxXml.wrapNode(xml)));
		nodes = Lambda.array(cast(result, XPathNodeSet).getNodes());
		assertEquals(14, nodes.length);
		assertEquals(xml, cast(nodes[0], XPathHxXml).getWrappedXml());
		assertEquals(a, cast(nodes[1], XPathHxXml).getWrappedXml());
		assertEquals(b, cast(nodes[2], XPathHxXml).getWrappedXml());
		assertEquals(c, cast(nodes[3], XPathHxXml).getWrappedXml());
		assertEquals(d, cast(nodes[4], XPathHxXml).getWrappedXml());
		assertEquals(e, cast(nodes[5], XPathHxXml).getWrappedXml());
		assertEquals(f, cast(nodes[6], XPathHxXml).getWrappedXml());
		assertEquals(g, cast(nodes[7], XPathHxXml).getWrappedXml());
		assertEquals(h, cast(nodes[8], XPathHxXml).getWrappedXml());
		assertEquals(i, cast(nodes[9], XPathHxXml).getWrappedXml());
		assertEquals(j, cast(nodes[10], XPathHxXml).getWrappedXml());
		assertEquals(k, cast(nodes[11], XPathHxXml).getWrappedXml());
		assertEquals(l, cast(nodes[12], XPathHxXml).getWrappedXml());
		assertEquals(m, cast(nodes[13], XPathHxXml).getWrappedXml());
		
		result = axisStep.evaluate(new FakeContext(XPathHxXml.wrapNode(l)));
		nodes = Lambda.array(cast(result, XPathNodeSet).getNodes());
		assertEquals(1, nodes.length);
		assertEquals(l, cast(nodes[0], XPathHxXml).getWrappedXml());
	}
	
	function testFollowing () {
		var axisStep = new AxisStep(Axis.Following);
		
		var result = axisStep.evaluate(new FakeContext(XPathHxXml.wrapNode(xml)));
		var nodes = Lambda.array(cast(result, XPathNodeSet).getNodes());
		assertEquals(13, nodes.length);
		assertEquals(a, cast(nodes[0], XPathHxXml).getWrappedXml());
		assertEquals(b, cast(nodes[1], XPathHxXml).getWrappedXml());
		assertEquals(c, cast(nodes[2], XPathHxXml).getWrappedXml());
		assertEquals(d, cast(nodes[3], XPathHxXml).getWrappedXml());
		assertEquals(e, cast(nodes[4], XPathHxXml).getWrappedXml());
		assertEquals(f, cast(nodes[5], XPathHxXml).getWrappedXml());
		assertEquals(g, cast(nodes[6], XPathHxXml).getWrappedXml());
		assertEquals(h, cast(nodes[7], XPathHxXml).getWrappedXml());
		assertEquals(i, cast(nodes[8], XPathHxXml).getWrappedXml());
		assertEquals(j, cast(nodes[9], XPathHxXml).getWrappedXml());
		assertEquals(k, cast(nodes[10], XPathHxXml).getWrappedXml());
		assertEquals(l, cast(nodes[11], XPathHxXml).getWrappedXml());
		assertEquals(m, cast(nodes[12], XPathHxXml).getWrappedXml());
		
		result = axisStep.evaluate(new FakeContext(XPathHxXml.wrapNode(i)));
		nodes = Lambda.array(cast(result, XPathNodeSet).getNodes());
		assertEquals(4, nodes.length);
		assertEquals(j, cast(nodes[0], XPathHxXml).getWrappedXml());
		assertEquals(k, cast(nodes[1], XPathHxXml).getWrappedXml());
		assertEquals(l, cast(nodes[2], XPathHxXml).getWrappedXml());
		assertEquals(m, cast(nodes[3], XPathHxXml).getWrappedXml());
		
		result = axisStep.evaluate(new FakeContext(XPathHxXml.wrapNode(m)));
		nodes = Lambda.array(cast(result, XPathNodeSet).getNodes());
		assertEquals(0, nodes.length);
	}
	
	function testFollowingSibling () {
		var axisStep = new AxisStep(Axis.FollowingSibling);
		
		var result = axisStep.evaluate(new FakeContext(XPathHxXml.wrapNode(xml)));
		var nodes = Lambda.array(cast(result, XPathNodeSet).getNodes());
		assertEquals(0, nodes.length);
		
		result = axisStep.evaluate(new FakeContext(XPathHxXml.wrapNode(e)));
		nodes = Lambda.array(cast(result, XPathNodeSet).getNodes());
		assertEquals(2, nodes.length);
		assertEquals(h, cast(nodes[0], XPathHxXml).getWrappedXml());
		assertEquals(j, cast(nodes[1], XPathHxXml).getWrappedXml());
	}
	
	// TODO: testNamespace
	
	function testParent () {
		var axisStep = new AxisStep(Axis.Parent);
		
		var result = axisStep.evaluate(new FakeContext(XPathHxXml.wrapNode(xml)));
		var nodes = Lambda.array(cast(result, XPathNodeSet).getNodes());
		assertEquals(0, nodes.length);
		
		result = axisStep.evaluate(new FakeContext(XPathHxXml.wrapNode(a)));
		nodes = Lambda.array(cast(result, XPathNodeSet).getNodes());
		assertEquals(1, nodes.length);
		assertEquals(xml, cast(nodes[0], XPathHxXml).getWrappedXml());
		
		result = axisStep.evaluate(new FakeContext(XPathHxXml.wrapNode(l)));
		nodes = Lambda.array(cast(result, XPathNodeSet).getNodes());
		assertEquals(1, nodes.length);
		assertEquals(k, cast(nodes[0], XPathHxXml).getWrappedXml());
	}
	
	function testPreceding () {
		var axisStep = new AxisStep(Axis.Preceding);
		
		var result = axisStep.evaluate(new FakeContext(XPathHxXml.wrapNode(xml)));
		var nodes = Lambda.array(cast(result, XPathNodeSet).getNodes());
		assertEquals(0, nodes.length);
		
		result = axisStep.evaluate(new FakeContext(XPathHxXml.wrapNode(i)));
		nodes = Lambda.array(cast(result, XPathNodeSet).getNodes());
		assertEquals(9, nodes.length);
		assertEquals(h, cast(nodes[0], XPathHxXml).getWrappedXml());
		assertEquals(g, cast(nodes[1], XPathHxXml).getWrappedXml());
		assertEquals(f, cast(nodes[2], XPathHxXml).getWrappedXml());
		assertEquals(e, cast(nodes[3], XPathHxXml).getWrappedXml());
		assertEquals(d, cast(nodes[4], XPathHxXml).getWrappedXml());
		assertEquals(c, cast(nodes[5], XPathHxXml).getWrappedXml());
		assertEquals(b, cast(nodes[6], XPathHxXml).getWrappedXml());
		assertEquals(a, cast(nodes[7], XPathHxXml).getWrappedXml());
		assertEquals(xml, cast(nodes[8], XPathHxXml).getWrappedXml());
		
		result = axisStep.evaluate(new FakeContext(XPathHxXml.wrapNode(m)));
		nodes = Lambda.array(cast(result, XPathNodeSet).getNodes());
		assertEquals(13, nodes.length);
		assertEquals(l, cast(nodes[0], XPathHxXml).getWrappedXml());
		assertEquals(k, cast(nodes[1], XPathHxXml).getWrappedXml());
		assertEquals(j, cast(nodes[2], XPathHxXml).getWrappedXml());
		assertEquals(i, cast(nodes[3], XPathHxXml).getWrappedXml());
		assertEquals(h, cast(nodes[4], XPathHxXml).getWrappedXml());
		assertEquals(g, cast(nodes[5], XPathHxXml).getWrappedXml());
		assertEquals(f, cast(nodes[6], XPathHxXml).getWrappedXml());
		assertEquals(e, cast(nodes[7], XPathHxXml).getWrappedXml());
		assertEquals(d, cast(nodes[8], XPathHxXml).getWrappedXml());
		assertEquals(c, cast(nodes[9], XPathHxXml).getWrappedXml());
		assertEquals(b, cast(nodes[10], XPathHxXml).getWrappedXml());
		assertEquals(a, cast(nodes[11], XPathHxXml).getWrappedXml());
		assertEquals(xml, cast(nodes[12], XPathHxXml).getWrappedXml());
	}
	
	function testPrecedingSibling () {
		var axisStep = new AxisStep(Axis.PrecedingSibling);
		
		var result = axisStep.evaluate(new FakeContext(XPathHxXml.wrapNode(xml)));
		var nodes = Lambda.array(cast(result, XPathNodeSet).getNodes());
		assertEquals(0, nodes.length);
		
		result = axisStep.evaluate(new FakeContext(XPathHxXml.wrapNode(h)));
		nodes = Lambda.array(cast(result, XPathNodeSet).getNodes());
		assertEquals(2, nodes.length);
		assertEquals(e, cast(nodes[0], XPathHxXml).getWrappedXml());
		assertEquals(d, cast(nodes[1], XPathHxXml).getWrappedXml());
	}
	
	function testSelf () {
		var axisStep = new AxisStep(Axis.Self);
		
		for (node in [xml, a, b, c, d, e, f, g, h, i, j, k, l, m]) {
			var result = axisStep.evaluate(new FakeContext(XPathHxXml.wrapNode(node)));
			var nodes = Lambda.array(cast(result, XPathNodeSet).getNodes());
			assertEquals(1, nodes.length);
			assertEquals(node, cast(nodes[0], XPathHxXml).getWrappedXml());
		}
	}
	
}
