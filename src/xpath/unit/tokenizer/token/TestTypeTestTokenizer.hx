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
import xpath.tokenizer.token.TypeTestTokenizer;
import xpath.token.TypeTestToken;


class TestTypeTestTokenizer extends TestCase {
	
	private var types:Hash<TypeTestEnum>;
	
	
	public function new () {
		super();
		
		types = new Hash<TypeTestEnum>();
		types.set("comment", Comment);
		types.set("text", Text);
		types.set("node", Node);
	}
	
	private function testGood () {
		for (type in types.keys()) {
			for (whitespace in ["", " ", "   "]) {
				for (garbage in ["", "cvjg802", "(F(*"]) {
					var state:TokenizeState = new TokenizeState(
						type + whitespace + "(" + whitespace + ")" + whitespace + garbage
					);
					state = TypeTestTokenizer.getInstance().tokenize(state);
					
					assertEquals(1, state.result.length);
					assertEquals(type.length + 2 + whitespace.length*3, state.pos);
					assertTrue(Std.is(state.result[0], TypeTestToken));
					assertEquals(types.get(type), cast(state.result[0], TypeTestToken).type);
				}
			}
		}
	}
	
	private function testBad () {
		for (type in types.keys()) {
			for (whitespace in ["", " ", "   "]) {
				for (garbage in ["", "cvjg802", "(F(*"]) {
					var state:TokenizeState = new TokenizeState(
						type + whitespace + "(" + whitespace + garbage
					);
					state = TypeTestTokenizer.getInstance().tokenize(state);
					
					assertEquals(null, state.result);
					assertEquals(0, state.pos);
				}
			}
		}
	}
	
}