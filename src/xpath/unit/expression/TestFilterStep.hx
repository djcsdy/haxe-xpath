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
import xpath.XPathEvaluationException;
import xpath.expression.Expression;
import xpath.expression.FilterStep;
import xpath.context.Context;
import xpath.context.Environment;
import xpath.context.DynamicEnvironment;
import xpath.type.XPathValue;
import xpath.type.XPathBoolean;
import xpath.type.XPathNumber;
import xpath.type.XPathString;
import xpath.type.XPathNodeSet;


class TestFilterStep extends TestCase {
	
	private var context:Context;
	
	
	public function new () {
		super();
		context = new Context(null, null, null, new DynamicEnvironment());
	}
	
	private function testFilterStep () {
		var nodeSet:Array<Xml> = [ Xml.createElement("a"), Xml.createElement("b") ];
		var filterStep:FilterStep = new FilterStep(new TestNodeSetExpression(nodeSet));
		var result:XPathValue = filterStep.evaluate(context);
		var nodes:Array<Xml> = cast(result, XPathNodeSet).getNodes();
		assertEquals(nodeSet, nodes);
		
		var caught:Bool = false;
		try {
			filterStep = new FilterStep(new TestStringExpression("foo"));
			result = filterStep.evaluate(context);
		} catch (e:XPathEvaluationException) {
			caught = true;
		}
		assertTrue(caught);
		
		caught = false;
		try {
			filterStep = new FilterStep(new TestNumericExpression(123));
			result = filterStep.evaluate(context);
		} catch (e:XPathEvaluationException) {
			caught = true;
		}
		assertTrue(caught);
		
		caught = false;
		try {
			filterStep = new FilterStep(new TestTrueExpression());
			result = filterStep.evaluate(context);
		} catch (e:XPathEvaluationException) {
			caught = true;
		}
		assertTrue(caught);
	}
	
}

private class TestNodeSetExpression extends Expression {
	
	private var value:Array<Xml>;
	
	
	public function new (value:Array<Xml>) {
		super(this);
		this.value = value;
	}
	
	public function evaluate(context:Context):XPathValue {
		return new XPathNodeSet(value);
	}
	
}

private class TestStringExpression extends Expression {
	
	private var value:String;
	
	
	public function new (value:String) {
		super(this);
		this.value = value;
	}
	
	public function evaluate (context:Context) :XPathValue {
		return new XPathString(value);
	}
	
}

private class TestNumericExpression extends Expression {
	
 	private var value:Float;
 	
 	
 	public function new (value:Float) {
 		super(this);
 		this.value = value;
 	}
 	
 	public function evaluate (context:Context) :XPathValue {
 		return new XPathNumber(value);
 	}
 	
}

private class TestTrueExpression extends Expression {
	
	public function new () {
		super(this);
	}
	
	public function evaluate (context:Context) :XPathValue {
		return new XPathBoolean(true);
	}
	
}

private class TestFalseExpression extends Expression {
	
	public function new () {
		super(this);
	}
	
	public function evaluate (context:Context) :XPathValue {
		return new XPathBoolean(false);
	}
	
}