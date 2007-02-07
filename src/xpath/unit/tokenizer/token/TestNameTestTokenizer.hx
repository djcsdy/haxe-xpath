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
import xpath.tokenizer.token.NameTestTokenizer;
import xpath.token.NameTestToken;


class TestNameTestTokenizer extends TestCase {
	
	private function testGood () {
		for (name in ["*", "ajf", "afdj:djbi", "a1nfdjvp", "AJFv:*", "fsd:ADfj", "__fsj:_fdks"]) {
			for (whitespace in ["", " ", "    "]) {
				var state:TokenizeState = new TokenizeState(name + whitespace);
				state = NameTestTokenizer.getInstance().tokenize(state);
				
				assertEquals(1, state.result.length);
				assertEquals(name.length + whitespace.length, state.pos);
				assertTrue(Std.is(state.result[0], NameTestToken));
				assertEquals(name, cast(state.result[0], NameTestToken).name);
			}
		}
	}
	
	private function testBad () {
		for (garbage in [
			" dgjj", "1dgjnsg", "-vkjkd", "$jgifjs", "%gfg", "@dgjgmn", "[fnh", "`fgnig", "{fhld",
			Std.chr(127) + "ghfsgk"
		]) {
			var state:TokenizeState = new TokenizeState(garbage);
			state = NameTestTokenizer.getInstance().tokenize(state);
			
			assertEquals(null, state.result);
			assertEquals(0, state.pos);
		}
	}
	
}