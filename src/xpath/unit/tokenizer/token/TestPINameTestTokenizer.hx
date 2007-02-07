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
import xpath.tokenizer.token.PINameTestTokenizer;
import xpath.token.PINameTestToken;


class TestPINameTestTokenizer extends TestCase {
	
	private function testGood () {
		for (whitespace in ["", " ", "   "]) {
			for (garbage in ["", "mgrsij4", ":fgs�%98385"]) {
				var state:TokenizeState = new TokenizeState(
					"processing-instruction" + whitespace + "(" + whitespace + ")" + whitespace + garbage
				);
				state = PINameTestTokenizer.getInstance().tokenize(state);
				
				assertEquals(1, state.result.length);
				assertEquals(24 + whitespace.length*3, state.pos);
				assertTrue(Std.is(state.result[0], PINameTestToken));
				assertEquals(null, cast(state.result[0], PINameTestToken).name);
				
				for (quote in ["'", '"']) {
					for (name in ["", "dfsjhg", "(�&UJFIONE�"]) {
						var state:TokenizeState = new TokenizeState(
							"processing-instruction" + whitespace + "(" + whitespace + quote + name +
							quote + whitespace + ")" + whitespace
						);
						state = PINameTestTokenizer.getInstance().tokenize(state);
						
						assertEquals(1, state.result.length);
						assertEquals(24 + whitespace.length*4 + quote.length*2 + name.length, state.pos);
						assertTrue(Std.is(state.result[0], PINameTestToken));
						assertEquals(name, cast(state.result[0], PINameTestToken).name);
					}
				}
			}
		}
	}
	
}