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


package xpath.unit.tokenizer.token;
import haxe.unit.TestCase;
import xpath.tokenizer.Tokenizer;
import xpath.tokenizer.TokenizeState;
import xpath.tokenizer.token.AbbreviatedStepTokenizer;
import xpath.token.AxisToken;
import xpath.token.TypeTestToken;


class TestAbbreviatedStepTokenizer extends TestCase {
	
	private function testGood () {
		for (whitespace in ["", " ", "      "]) {
			for (xpathStr in [".", ".."]) {
				for (garbage in ["", ",b,ndsjg", "#dsgjg"]) {
					var extraGarbages:Array<String>;
					if (xpathStr == "..") extraGarbages = ["", "."];
					else extraGarbages = [""];
					
					for (extraGarbage in extraGarbages) {
						var state:TokenizeState = new TokenizeState(xpathStr+whitespace+extraGarbage+garbage);
						state = AbbreviatedStepTokenizer.getInstance().tokenize(state);
						
						assertEquals(2, state.result.length);
						assertEquals(xpathStr.length + whitespace.length, state.pos);
						assertTrue(Std.is(state.result[0], AxisToken));
						if (xpathStr == ".") {
							assertEquals(Self, cast(state.result[0], AxisToken).axis);
						} else {
							assertEquals(Parent, cast(state.result[0], AxisToken).axis);
						}
						assertTrue(Std.is(state.result[1], TypeTestToken));
						assertEquals(Node, cast(state.result[1], TypeTestToken).type);
					}
				}
			}			
		}
	}
	
	private function testBad () {
		for (garbage in ["", ",vxcgsfp", "/#vxcbkprsjg"]) {
			var state:TokenizeState = new TokenizeState(garbage);
			state = AbbreviatedStepTokenizer.getInstance().tokenize(state);
			
			assertEquals(null, state.result);
			assertEquals(0, state.pos);
		}
	}
	
}