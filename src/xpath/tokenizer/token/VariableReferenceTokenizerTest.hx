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
import xpath.tokenizer.token.VariableReferenceTokenizer;
import xpath.tokenizer.Token;
import xpath.tokenizer.ExpectedException;


class VariableReferenceTokenizerTest extends TestCase {
	
	function testGood () {
		for (name in ["ajf", "afdj:djbi", "a1nfdjvp", "AJFvmado", "fsd:ADfj", "__fsj:_fdks"]) {
			for (whitespace in ["", " ", "    "]) {
				for (garbage in ["", "!cxvpsf", "/c./ ,", "(jdfsjfp"]) {
					var input = new TokenizerInput(
						"$" + name + whitespace + garbage
					);
					var output = VariableReferenceTokenizer.getInstance().tokenize(input);
					
					assertEquals(1, output.result.length);
					assertEquals(1 + name.length + whitespace.length, output.characterLength);
					assertTrue(Std.is(output.result[0], VariableReferenceToken));
					assertEquals(name, cast(output.result[0], VariableReferenceToken).name);
				}
			}
		}
	}
	
	function testBad () {
		for (whitespace in ["", " ", "    "]) {
			for (garbage in ["", "!cxvpsf", "/c./ ,"]) {
				for (name in [
					"ajf", "afdj:djbi", "a1nfdjvp", "AJFvmado", "fsd:ADfj", "__fsj:_fdks"
				]) {
					var input = new TokenizerInput(name + whitespace + garbage);
					
					var caught = false;
					try {
						VariableReferenceTokenizer.getInstance().tokenize(input);
					} catch (exception:ExpectedException) {
						caught = true;
						assertEquals(0, exception.position);
					}
					assertTrue(caught);
				}
			}
		}
			
		for (garbage in [
			" dgjj", "1dgjnsg", "-vkjkd", "$jgifjs", "%gfg", "@dgjgmn", "[fnh", "`fgnig", "{fhld",
			String.fromCharCode(127) + "ghfsgk"
		]) {
			var input = new TokenizerInput("$" + garbage);
			
			var caught = false;
			try {
				VariableReferenceTokenizer.getInstance().tokenize(input);
			} catch (exception:ExpectedException) {
				caught = true;
				assertEquals(0, exception.position);
			}
			assertTrue(caught);
		}
	}
	
}
