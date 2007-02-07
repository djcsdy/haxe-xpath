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


package xpath.unit.tokenizer.token;
import haxe.unit.TestCase;
import xpath.tokenizer.Tokenizer;
import xpath.tokenizer.TokenizeState;
import xpath.tokenizer.token.AxisTokenizer;
import xpath.token.AxisToken;


class TestAxisTokenizer extends TestCase {
	
	private var axes:Hash<AxisEnum>;
	
	
	public function new () {
		super();
		axes = new Hash<AxisEnum>();
		axes.set("ancestor", Ancestor);
		axes.set("ancestor-or-self", AncestorOrSelf);
		axes.set("attribute", Attribute);
		axes.set("child", Child);
		axes.set("descendant", Descendant);
		axes.set("descendant-or-self", DescendantOrSelf);
		axes.set("following", Following);
		axes.set("following-sibling", FollowingSibling);
		axes.set("namespace", Namespace);
		axes.set("parent", Parent);
		axes.set("preceding", Preceding);
		axes.set("preceding-sibling", PrecedingSibling);
		axes.set("self", Self);
	}

	private function testGood () {
		for (whitespace in ["", " ", "    "]) {
			for (garbage in ["", "fmnvisfjg-", "cx. ]", "?MVCZ"]) {
				for (extraGarbage in ["", ":"]) {
					for (axisName in axes.keys()) {
						for (whitespace2 in ["", " ", "    "]) {
							var state:TokenizeState = new TokenizeState(
								axisName + whitespace + "::" + whitespace2 + extraGarbage + garbage
							);
							state = AxisTokenizer.getInstance().tokenize(state);
							
							assertEquals(1, state.result.length);
							assertEquals(
								axisName.length + whitespace.length + 2 + whitespace2.length, state.pos
							);
							assertTrue(Std.is(state.result[0], AxisToken));
							assertEquals(axes.get(axisName), cast(state.result[0], AxisToken).axis);
						}

						var state:TokenizeState = new TokenizeState(
							axisName + whitespace + extraGarbage + garbage
						);
						state = AxisTokenizer.getInstance().tokenize(state);
						
						assertEquals(1, state.result.length);
						assertEquals(0, state.pos);
						assertTrue(Std.is(state.result[0], AxisToken));
						assertEquals(Child, cast(state.result[0], AxisToken).axis);
					}
				}

				var state:TokenizeState = new TokenizeState("@" + whitespace + garbage);
				state = AxisTokenizer.getInstance().tokenize(state);
				
				assertEquals(1, state.result.length);
				assertEquals(1 + whitespace.length, state.pos);
				assertTrue(Std.is(state.result[0], AxisToken));
				assertEquals(Attribute, cast(state.result[0], AxisToken).axis);
				
				state = new TokenizeState(whitespace + garbage);
				state = AxisTokenizer.getInstance().tokenize(state);
				
				assertEquals(1, state.result.length);
				assertEquals(whitespace.length, state.pos);
				assertTrue(Std.is(state.result[0], AxisToken));
				assertEquals(Child, cast(state.result[0], AxisToken).axis);
			}
		}
	}
	
}