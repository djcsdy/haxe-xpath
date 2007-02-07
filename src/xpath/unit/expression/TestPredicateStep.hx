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
import xpath.expression.Expression;
import xpath.expression.PredicateStep;
import xpath.context.Context;
import xpath.context.Environment;
import xpath.context.DynamicEnvironment;
import xpath.type.XPathValue;
import xpath.type.XPathNodeSet;
import xpath.type.XPathNumber;
import xpath.type.XPathBoolean;


class TestPredicateStep extends TestCase {
	
	private var environment:Environment;
	
	
	public function new () {
		super();
		environment = new DynamicEnvironment();
	}
	
	private function testNumber () {
		var element:Xml = Xml.createElement("foo");
		
		for (position in [1, 5, 10]) {
			for (expressionValue in [1, 5, 10]) {
				var expression:Expression = new TestNumericExpression(expressionValue);
				var predicateStep:PredicateStep = new PredicateStep(expression);
				var result:XPathValue = predicateStep.evaluate(new Context(
					element, position, 20, environment)
				);
				var nodes:Array<Xml> = cast(result, XPathNodeSet).getNodes();
				
				if  (position == expressionValue) {
					assertEquals(element, nodes[0]);
				} else {
					assertEquals(0, nodes.length);
				}
			}
		}
	}
	
	private function testBool () {
		var element:Xml = Xml.createElement("foo");
		
		var predicateStep:PredicateStep = new PredicateStep(new TestTrueExpression());
		var result:XPathValue = predicateStep.evaluate(new Context(element, 1, 1, environment));
		var nodes:Array<Xml> = cast(result, XPathNodeSet).getNodes();
		assertEquals(element, nodes[0]);
		
		predicateStep = new PredicateStep(new TestFalseExpression());
		result = predicateStep.evaluate(new Context(element, 1, 1, environment));
		nodes = cast(result, XPathNodeSet).getNodes();
		assertEquals(0, nodes.length);
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