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
import xpath.context.Context;
import xpath.context.FakeContext;
import xpath.value.XPathNodeSet;
import xpath.xml.XPathXml;
import xpath.xml.XPathHxXml;
import xpath.Axis;


class PathStepTest extends TestCase {
	
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
	private var xml :Xml;
	private var a :Xml;
	private var b :Xml;
	private var c :Xml;
	private var d :Xml;
	private var e :Xml;
	private var f :Xml;
	private var g :Xml;
	private var h :Xml;
	private var i :Xml;
	private var j :Xml;
	private var k :Xml;
	private var l :Xml;
	private var m :Xml;
	
	
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
	
	private function testContext () {
		var fakeEvensStep = new FakeEvensStep();
		var fakeChildrenStep = new FakeChildrenStep(fakeEvensStep);
		
		var result = fakeChildrenStep.evaluate(new FakeContext(
			XPathHxXml.wrapNode(a)
		));
		var nodes = Lambda.array(cast(result, XPathNodeSet).getNodes());
		assertEquals(1, fakeChildrenStep.inLog.length);
		assertEquals(
			a, cast(fakeChildrenStep.inLog[0], XPathHxXml).getWrappedXml()
		);
		assertEquals(4, fakeChildrenStep.outLog.length);
		assertEquals(
			b, cast(fakeChildrenStep.outLog[0], XPathHxXml).getWrappedXml()
		);
		assertEquals(
			c, cast(fakeChildrenStep.outLog[1], XPathHxXml).getWrappedXml()
		);
		assertEquals(
			k, cast(fakeChildrenStep.outLog[2], XPathHxXml).getWrappedXml()
		);
		assertEquals(
			m, cast(fakeChildrenStep.outLog[3], XPathHxXml).getWrappedXml()
		);
		assertEquals(4, fakeEvensStep.inLog.length);
		assertEquals(
			b, cast(fakeEvensStep.inLog[0], XPathHxXml).getWrappedXml()
		);
		assertEquals(
			c, cast(fakeEvensStep.inLog[1], XPathHxXml).getWrappedXml()
		);
		assertEquals(
			k, cast(fakeEvensStep.inLog[2], XPathHxXml).getWrappedXml()
		);
		assertEquals(
			m, cast(fakeEvensStep.inLog[3], XPathHxXml).getWrappedXml()
		);
		assertEquals(2, fakeEvensStep.outLog.length);
		assertEquals(
			c, cast(fakeEvensStep.outLog[0], XPathHxXml).getWrappedXml()
		);
		assertEquals(
			m, cast(fakeEvensStep.outLog[1], XPathHxXml).getWrappedXml()
		);
		assertEquals(2, nodes.length);
		assertEquals(c, cast(nodes[0], XPathHxXml).getWrappedXml());
		assertEquals(m, cast(nodes[1], XPathHxXml).getWrappedXml());
	}
	
}

private class FakeChildrenStep extends PathStep {
	
	public var inLog (default, null) :Array<XPathXml>;
	public var outLog (default, null) :Array<XPathXml>;
	
	
	public function new (?nextStep:PathStep) {
		super(fakeChildrenStep, nextStep);
		inLog = new Array<XPathXml>();
		outLog = new Array<XPathXml>();
	}
	
	function fakeChildrenStep (context:Context) {
		inLog.push(context.node);
		var result = Lambda.array(context.node.getAxisIterable(Axis.Child));
		outLog = outLog.concat(result);
		return result;
	}
	
}

private class FakeEvensStep extends PathStep {
	
	public var inLog (default, null) :Array<XPathXml>;
	public var outLog (default, null) :Array<XPathXml>;
	
	
	public function new (?nextStep:PathStep) {
		super(fakeEvensStep, nextStep);
		inLog = new Array<XPathXml>();
		outLog = new Array<XPathXml>();
	}
	
	function fakeEvensStep (context:Context) {
		inLog.push(context.node);
		if (context.position%2 == 0) {
			outLog.push(context.node);
			return [context.node];
		} else {
			return [];
		}
	}
	
}

