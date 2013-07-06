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
import haxe.unit.TestCase;
import xpath.tokenizer.Tokenizer;
import xpath.tokenizer.TokenizerInput;
import xpath.tokenizer.token.EndFunctionCallTokenizer;
import xpath.tokenizer.Token;
import xpath.tokenizer.ExpectedException;


class EndFunctionCallTokenizerTest extends TestCase {
	
	function testGood () {
		for (whitespace in ["", " ", "    "]) {
			for (garbage in ["dsklfg", "vsv", "cv.' sd"]) {
				var input = new TokenizerInput(")" + whitespace + garbage);
				var output = EndFunctionCallTokenizer.getInstance().tokenize(input);
				
				assertEquals(1, output.result.length);
				assertEquals(1 + whitespace.length, output.characterLength);
				assertTrue(Std.is(output.result[0], EndFunctionCallToken));
			}
		}
	}
	
	function testBad () {
		for (whitespace in ["", " ", "    "]) {
			for (garbage in ["", "dsklfg", "vsv", "cv.' sd"]) {
				var input = new TokenizerInput(whitespace + garbage);
				
				var caught = false;
				try {
					EndFunctionCallTokenizer.getInstance().tokenize(input);
				} catch (exception:ExpectedException) {
					caught = true;
					assertEquals(0, exception.position);
				}
				assertTrue(caught);
			}
		}
	}
	
}
