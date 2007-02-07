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


package xpath.unit.tokenizer;
import haxe.unit.TestCase;
import xpath.tokenizer.TokenizeState;
import xpath.token.Token;
import xpath.token.AxisToken;
import xpath.token.NameTestToken;
import xpath.token.StepDelimiterToken;


class TestTokenizeState extends TestCase {
	
	private function testNew () {
		var state:TokenizeState = new TokenizeState("ABCDEFG");
		assertEquals("ABCDEFG", state.xpathStr);
		assertEquals(0, state.pos);
		assertEquals(null, state.result);
	}
	
	private function testPos () {
		var testString:String = "ABCDEFG";
		var state:TokenizeState = new TokenizeState(testString);
		
		for (i in 0...testString.length+1) {
			state.pos = i;
			assertEquals(i, state.pos);
		}
		state.pos = testString.length+1;
		assertEquals(null, state.pos);
		state.pos = -1;
		assertEquals(null, state.pos);
	}
	
	private function testResult () {
		var state:TokenizeState = new TokenizeState("ABCDEFG");
		assertEquals(null, state.result);
		
		var a:AxisToken = new AxisToken(Child);
		var b:NameTestToken = new NameTestToken("div");
		var c:StepDelimiterToken = new StepDelimiterToken();
		var d:AxisToken = new AxisToken(Descendant);
		var e:NameTestToken = new NameTestToken("p");
		
		state.result = [ cast(a, Token), b, c, d, e ];
		assertEquals(a, cast(state.result[0], AxisToken));
		assertEquals(b, cast(state.result[1], NameTestToken));
		assertEquals(c, cast(state.result[2], StepDelimiterToken));
		assertEquals(d, cast(state.result[3], AxisToken));
		assertEquals(e, cast(state.result[4], NameTestToken));
		assertEquals(null, state.result[5]);
	}
	
	private function testNewWorkingCopy () {
		var state:TokenizeState = new TokenizeState("ABCDEFG");
		state.pos = 3;
		
		var a:AxisToken = new AxisToken(Child);
		var b:NameTestToken = new NameTestToken("div");
		var c:StepDelimiterToken = new StepDelimiterToken();
		var d:AxisToken = new AxisToken(Descendant);
		var e:NameTestToken = new NameTestToken("p");

		var newState:TokenizeState = state.newWorkingCopy();
		assertEquals(state.xpathStr, newState.xpathStr);
		assertEquals(state.pos, newState.pos);
		assertEquals(null, newState.result);
	}		
	
}