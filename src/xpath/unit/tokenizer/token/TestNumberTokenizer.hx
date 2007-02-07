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
import xpath.tokenizer.token.NumberTokenizer;
import xpath.token.NumberToken;


class TestNumberTokenizer extends TestCase {

	private function testGood () {
		for (number in ["5", "537895", ".3489", "38598."]) {
			for (whitespace in ["", " ", "    "]) {
				for (garbage in ["", "djgsogj", "!$()£*"]) {
					var state:TokenizeState = new TokenizeState(number + whitespace + garbage);
					state = NumberTokenizer.getInstance().tokenize(state);
					
					assertEquals(1, state.result.length);
					assertEquals(number.length + whitespace.length, state.pos);
					assertTrue(Std.is(state.result[0], NumberToken));
					assertEquals(Std.parseFloat(number), cast(state.result[0], NumberToken).value);
				}
			}
		}
	}
	
	private function testBad () {
		for (garbage in ["", ".", ".sfjgs0", "sgj3.", "(£*%)"]) {
			var state:TokenizeState = new TokenizeState(garbage);
			state = NumberTokenizer.getInstance().tokenize(state);
			
			assertEquals(null, state.result);
			assertEquals(0, state.pos);
		}
	}
	
}