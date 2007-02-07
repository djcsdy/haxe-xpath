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


package xpath.unit.parser;
import haxe.unit.TestCase;
import xpath.parser.PathParser;
import xpath.parser.ParseState;
import xpath.token.Token;
import xpath.token.BeginPathToken;
import xpath.token.EndPathToken;
import xpath.token.StepDelimiterToken;
import xpath.token.AxisToken;
import xpath.token.TypeTestToken;
import xpath.expression.RootStep;
import xpath.expression.TypeStep;
import xpath.expression.AxisStep;


class TestPathParser extends TestCase {
	
	private function testRoot () {
		var state:ParseState = new ParseState([
			cast(new BeginPathToken(), Token), new StepDelimiterToken(), new EndPathToken()
		]);
		state = PathParser.getInstance().parse(state);
		
		assertEquals(3, state.pos);
		assertTrue(Std.is(state.result, RootStep));
		assertEquals(null, Reflect.field(state.result, "next"));
	}
	
	private function testSelf () {
		var state:ParseState = new ParseState([
			cast(new BeginPathToken(), Token), new AxisToken(Self), new TypeTestToken(Node),
			new EndPathToken()
		]);
		state = PathParser.getInstance().parse(state);
		
		assertEquals(4, state.pos);
		assertTrue(Std.is(state.result, TypeStep));
		assertEquals(null, Reflect.field(state.result, "next"));
		assertEquals(TypeTestEnum.Node, Reflect.field(state.result, "type"));
	}
	
	private function testRootSelf () {
		var state:ParseState = new ParseState([
			cast(new BeginPathToken(), Token), new StepDelimiterToken(), new AxisToken(Self),
			new TypeTestToken(Node), new EndPathToken()
		]);
		state = PathParser.getInstance().parse(state);
		
		assertEquals(5, state.pos);
		assertTrue(Std.is(state.result, RootStep));
		assertEquals(null, Reflect.field(state.result, "next"));
	}
	
	private function testChildChild () {
		var state:ParseState = new ParseState([
			cast(new BeginPathToken(), Token), new AxisToken(Child), new TypeTestToken(Node),
			new AxisToken(Child), new TypeTestToken(Node), new EndPathToken()
		]);
		state = PathParser.getInstance().parse(state);
		
		assertEquals(6, state.pos);
		assertTrue(Std.is(state.result, AxisStep));
		assertEquals(AxisEnum.Child, Reflect.field(state.result, "axis"));
		assertTrue(Std.is(Reflect.field(state.result, "next"), AxisStep));
		var next:AxisStep = cast(Reflect.field(state.result, "next"), AxisStep);
		assertEquals(AxisEnum.Child, Reflect.field(next, "axis"));
		assertEquals(null, Reflect.field(next, "next"));
	}
	
}