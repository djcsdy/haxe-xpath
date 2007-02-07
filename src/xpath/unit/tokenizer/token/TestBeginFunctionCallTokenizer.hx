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
import xpath.tokenizer.token.BeginFunctionCallTokenizer;
import xpath.token.BeginFunctionCallToken;


class TestBeginFunctionCallTokenizer extends TestCase {
	
	private function testGood () {
		for (functionName in ["ajf", "afdj:djbi", "a1nfdjvp", "AJFvmado", "fsd:ADfj", "__fsj:_fdks"]) {
			for (whitespace in ["", " ", "    "]) {
				for (whitespace2 in ["", " ", "   "]) {
					for (garbage in ["", "cxvpsf", "/c./ ,", "(jdfsjfp"]) {
						var state:TokenizeState = new TokenizeState(
							functionName + whitespace + "(" + whitespace2 + garbage
						);
						state = BeginFunctionCallTokenizer.getInstance().tokenize(state);
						
						assertEquals(1, state.result.length);
						assertEquals(
							functionName.length + whitespace.length + 1 + whitespace2.length, state.pos
						);
						assertTrue(Std.is(state.result[0], BeginFunctionCallToken));
						assertEquals(functionName, cast(state.result[0], BeginFunctionCallToken).name);
					}
				}
			}
		}
	}
	
	private function testBad () {
		for (whitespace in ["", " ", "    "]) {
			for (garbage in ["", "cxvpsf", "/c./ ,"]) {
				for (functionName in [
					"ajf", "afdj:djbi", "a1nfdjvp", "AJFvmado", "fsd:ADfj", "__fsj:_fdks"
				]) {
					var state:TokenizeState = new TokenizeState(
						functionName + whitespace + garbage
					);
					state = BeginFunctionCallTokenizer.getInstance().tokenize(state);
					
					assertEquals(null, state.result);
					assertEquals(0, state.pos);
				}
			}
			
			for (garbage in [
				" dgjj", "1dgjnsg", "-vkjkd", "$jgifjs", "%gfg", "@dgjgmn", "[fnh", "`fgnig", "{fhld",
				Std.chr(127) + "ghfsgk"
			]) {
				for (whitespace2 in ["", " ", "   "]) {
					var state:TokenizeState = new TokenizeState(
						garbage + whitespace + "(" + whitespace2
					);
					state = BeginFunctionCallTokenizer.getInstance().tokenize(state);
					
					assertEquals(null, state.result);
					assertEquals(0, state.pos);
				}
			}
		}
	}
	
}