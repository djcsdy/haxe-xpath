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


package xpath.unit.expression;
import haxe.unit.TestCase;
import dcxml.Xml;
import xpath.expression.PathStep;
import xpath.context.Context;
import xpath.context.Environment;
import xpath.context.DynamicEnvironment;
import xpath.type.XPathNodeSet;


class TestPathStep extends TestCase {
	
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
	
	private function testContext () {
		var t:TestEvensStep = new TestEvensStep();
		var s:TestChildrenStep = new TestChildrenStep(t);
		
		var result:XPathNodeSet = s.evaluate(new Context(a, 1, 1, environment));
		var nodes:Array<Xml> = result.getNodes();
		assertEquals(1, s.inLog.length);
		assertEquals(a, s.inLog[0]);
		assertEquals(4, s.outLog.length);
		assertEquals(b, s.outLog[0]);
		assertEquals(c, s.outLog[1]);
		assertEquals(k, s.outLog[2]);
		assertEquals(m, s.outLog[3]);
		assertEquals(4, t.inLog.length);
		assertEquals(b, t.inLog[0]);
		assertEquals(c, t.inLog[1]);
		assertEquals(k, t.inLog[2]);
		assertEquals(m, t.inLog[3]);
		assertEquals(2, t.outLog.length);
		assertEquals(c, t.outLog[0]);
		assertEquals(m, t.outLog[1]);
		assertEquals(2, nodes.length);
		assertEquals(c, nodes[0]);
		assertEquals(m, nodes[1]);
	}
	
}

private class TestChildrenStep extends PathStep {
	
	public var inLog(default, null):Array<Xml>;
	public var outLog(default, null):Array<Xml>;
	
	
	public function new (?next:PathStep) {
		super(this, next);
		inLog = new Array<Xml>();
		outLog = new Array<Xml>();
	}
	
	private function step (context:Context) :Array<Xml> {
		inLog.push(context.node);
		var result:Array<Xml> = new Array<Xml>();
		for (node in context.node) {
			result.push(node);
			outLog.push(node);
		}
		return result;
	}

}

private class TestEvensStep extends PathStep {
	
	public var inLog(default, null):Array<Xml>;
	public var outLog(default, null):Array<Xml>;
	
	
	public function new (?next:PathStep) {
		super(this, next);
		inLog = new Array<Xml>();
		outLog = new Array<Xml>();
	}
	
	private function step (context:Context) :Array<Xml> {
		inLog.push(context.node);
		if (context.position%2 == 0) {
			outLog.push(context.node);
			return [context.node];
		} else {
			return [];
		}
	}
	
}