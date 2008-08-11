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


package xpath.tokenizer.token;
import haxe.unit.TestCase;
import xpath.tokenizer.Tokenizer;
import xpath.tokenizer.TokenizerInput;
import xpath.tokenizer.token.NumberTokenizer;
import xpath.tokenizer.Token;
import xpath.tokenizer.ExpectedException;


class NumberTokenizerTest extends TestCase {

	function testGood () {
		for (number in ["5", "537895", ".3489", "38598."]) {
			for (whitespace in ["", " ", "    "]) {
				for (garbage in ["", "djgsogj", "!$()�*"]) {
					var input = new TokenizerInput(number + whitespace + garbage);
					var output = NumberTokenizer.getInstance().tokenize(input);
					
					assertEquals(1, output.result.length);
					assertEquals(number.length + whitespace.length, output.characterLength);
					assertTrue(Std.is(output.result[0], NumberToken));
					assertEquals(Std.parseFloat(number), cast(output.result[0], NumberToken).value);
				}
			}
		}
	}
	
	function testBad () {
		for (garbage in ["", ".", ".sfjgs0", "sgj3.", "(�*%)"]) {
			var input = new TokenizerInput(garbage);
			
			var caught = false;
			try {
				NumberTokenizer.getInstance().tokenize(input);
			} catch (exception:ExpectedException) {
				caught = true;
				assertEquals(0, exception.position);
			}
			assertTrue(caught);
		}
	}
	
}
