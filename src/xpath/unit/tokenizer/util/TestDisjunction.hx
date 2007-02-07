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


package xpath.unit.tokenizer.util;
import haxe.unit.TestCase;
import xpath.unit.tokenizer.util._TestUtil;
import xpath.tokenizer.util.Disjunction;
import xpath.tokenizer.Tokenizer;
import xpath.tokenizer.TokenizeState;
import xpath.token.Token;


class TestDisjunction extends TestCase {
	
	public function testAll () {
		var state:TokenizeState = new TokenizeState("abaaazzz");
		
		var tokenizer:Tokenizer = new Disjunction([
			cast(new StringTokenizer("a"), Tokenizer), new StringTokenizer("b"),
			new StringTokenizer("aa")
		]);
		state = tokenizer.tokenize(state);
		assertEquals(1, state.pos);
		assertEquals(1, state.result.length);
		assertTrue(Std.is(state.result[0], StringToken));
		assertEquals("a", cast(state.result[0], StringToken).string);
		
		state = tokenizer.tokenize(state);
		assertEquals(2, state.pos);
		assertEquals(1, state.result.length);
		assertTrue(Std.is(state.result[0], StringToken));
		assertEquals("b", cast(state.result[0], StringToken).string);

		state = tokenizer.tokenize(state);
		assertEquals(4, state.pos);
		assertEquals(1, state.result.length);
		assertTrue(Std.is(state.result[0], StringToken));
		assertEquals("aa", cast(state.result[0], StringToken).string);

		state = tokenizer.tokenize(state);
		assertEquals(5, state.pos);
		assertEquals(1, state.result.length);
		assertTrue(Std.is(state.result[0], StringToken));
		assertEquals("a", cast(state.result[0], StringToken).string);
		
		state = tokenizer.tokenize(state);
		assertEquals(5, state.pos);
		assertEquals(null, state.result);
	}
}

class StringToken extends Token {
	
	public var string(default, null):String;
	
	
	public function new (string:String) {
		this.string = string;
	}
	
}

class StringTokenizer implements Tokenizer {
	
	private var string:String;
	
	
	public function new (string:String) {
		this.string = string;
	}
	
	public function tokenize (state:TokenizeState) :TokenizeState {
		if (state.xpathStr.substr(state.pos, string.length) == string) {
			var resultState = state.newWorkingCopy();
			resultState.pos += string.length;
			resultState.result = [ cast(new StringToken(string), Token) ];
			return resultState;
		} else {
			return state.newWorkingCopy();
		}
	}
	
}
