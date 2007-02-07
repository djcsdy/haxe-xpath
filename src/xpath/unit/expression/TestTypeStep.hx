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
import xpath.expression.TypeStep;
import xpath.context.Context;
import xpath.context.Environment;
import xpath.context.DynamicEnvironment;
import xpath.token.TypeTestToken;
import xpath.type.XPathValue;
import xpath.type.XPathNodeSet;


class TestTypeStep extends TestCase {
	
	private var environment:Environment;
	

	public function new () {
		super();
		environment = new DynamicEnvironment();
	}

	private function testNode () {
		var typeStep:TypeStep = new TypeStep(Node);
		var element:Xml = Xml.createElement("foo");
		var result:XPathValue = typeStep.evaluate(new Context(element, 1, 1, environment));
		var nodes:Array<Xml> = cast(result, XPathNodeSet).getNodes();
		
		assertEquals(element, nodes[0]);
	}
	
	private function testText () {
		var typeStep:TypeStep = new TypeStep(TypeTestEnum.Text);
		var element:Xml = Xml.createElement("foo");
		var text:Xml = Xml.createText("blabla");
		
		var result:XPathValue = typeStep.evaluate(new Context(element, 1, 1, environment));
		var nodes:Array<Xml> = cast(result, XPathNodeSet).getNodes();
		assertEquals(0, nodes.length);
		
		result = typeStep.evaluate(new Context(text, 1, 1, environment));
		nodes = cast(result, XPathNodeSet).getNodes();
		assertEquals(text, nodes[0]);
	}
	
	// TODO testComment ()
	
}