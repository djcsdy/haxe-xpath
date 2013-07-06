/* Haxe XPath by Daniel J. Cassidy <mail@danielcassidy.me.uk>
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


package xpath.tokenizer.token;
import Haxe.unit.TestCase;
import xpath.tokenizer.Tokenizer;
import xpath.tokenizer.TokenizerInput;
import xpath.tokenizer.token.LiteralTokenizer;
import xpath.tokenizer.Token;
import xpath.tokenizer.ExpectedException;


class LiteralTokenizerTest extends TestCase {
	
	var otherQuotes :Hash<String>;
	
	
	public function new () {
		super();
		otherQuotes = new Hash<String>();
		otherQuotes.set("'", '"');
		otherQuotes.set('"', "'");
	}
	
	function testGood () {
		for (quote in ["'", '"']) {
			var otherQuote:String = otherQuotes.get(quote);
			
			for (literal in ["", "sdjf", otherQuote, "NVIsnjnfg" + otherQuote + "235 <XV"]) {
				for (whitespace in ["", " ", "   "]) {
					for (garbage in [
						"", "jfgbnxvv u00U()", quote, otherQuote, otherQuote + quote,
						quote + otherQuote, quote + quote, otherQuote + otherQuote
					]) {
						var input = new TokenizerInput(
							quote + literal + quote + whitespace + garbage
						);
						var output = LiteralTokenizer.getInstance().tokenize(input);
						
						assertEquals(1, output.result.length);
						assertEquals(
							quote.length + literal.length + quote.length +
							whitespace.length, output.characterLength
						);
						assertTrue(Std.is(output.result[0], LiteralToken));
						assertEquals(literal, cast(output.result[0], LiteralToken).value);
					}
				}
			}
		}
	}
	
	function testBad () {
		for (quote in ["'", '"']) {
			var otherQuote:String = otherQuotes.get(quote);
			
			for (literal in ["", "sdjf", otherQuote, "NVIsnjnfg" + otherQuote + "235 <XV"]) {
				for (whitespace in ["", " ", "   "]) {
					for (garbage in ["", "jfgbnxvv u00U()", "193<C<ZM", "|>"]) {
						var input = new TokenizerInput(
							quote + literal + otherQuote + whitespace + garbage
						);
						
						var caught = false;
						try {
							LiteralTokenizer.getInstance().tokenize(input);
						} catch (exception:ExpectedException) {
							caught = true;
							assertEquals(0, exception.position);
						}
						assertTrue(caught);
					}
				}
			}
		}
	}
	
}
