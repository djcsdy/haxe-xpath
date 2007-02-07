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
import xpath.tokenizer.token.LiteralTokenizer;
import xpath.token.LiteralToken;


class TestLiteralTokenizer extends TestCase {
	
	private var otherQuotes:Hash<String>;
	
	
	public function new () {
		super();
		otherQuotes = new Hash<String>();
		otherQuotes.set("'", '"');
		otherQuotes.set('"', "'");
	}
	
	private function testGood () {
		for (quote in ["'", '"']) {
			var otherQuote:String = otherQuotes.get(quote);
			
			for (literal in ["", "sdjf", otherQuote, "NVIsnjnfg" + otherQuote + "235 <XV"]) {
				for (whitespace in ["", " ", "   "]) {
					for (garbage in [
						"", "jfgbnxvv u00U()", quote, otherQuote, otherQuote + quote,
						quote + otherQuote, quote + quote, otherQuote + otherQuote
					]) {
						var state:TokenizeState = new TokenizeState(
							quote + literal + quote + whitespace + garbage
						);
						state = LiteralTokenizer.getInstance().tokenize(state);
						
						assertEquals(1, state.result.length);
						assertEquals(
							quote.length + literal.length + quote.length + whitespace.length, state.pos
						);
						assertTrue(Std.is(state.result[0], LiteralToken));
						assertEquals(literal, cast(state.result[0], LiteralToken).value);
					}
				}
			}
		}
	}
	
	private function testBad () {
		for (quote in ["'", '"']) {
			var otherQuote:String = otherQuotes.get(quote);
			
			for (literal in ["", "sdjf", otherQuote, "NVIsnjnfg" + otherQuote + "235 <XV"]) {
				for (whitespace in ["", " ", "   "]) {
					for (garbage in ["", "jfgbnxvv u00U()", "193<C<ZM", "|>"]) {
						var state:TokenizeState = new TokenizeState(
							quote + literal + otherQuote + whitespace + garbage
						);
						state = LiteralTokenizer.getInstance().tokenize(state);
						
						assertEquals(null, state.result);
						assertEquals(0, state.pos);
					}
				}
			}
		}
	}
	
}