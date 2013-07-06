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
import xpath.tokenizer.token.TypeTestTokenizer;
import xpath.tokenizer.Token;
import xpath.tokenizer.ExpectedException;
import xpath.NodeCategory;


class TypeTestTokenizerTest extends TestCase {
	
	var types :Hash<NodeCategory>;
	
	
	public function new () {
		super();
		
		types = new Hash<NodeCategory>();
		types.set("comment", Comment);
		types.set("text", Text);
		types.set("node", Node);
	}
	
	function testGood () {
		for (type in types.keys()) {
			for (whitespace in ["", " ", "   "]) {
				for (garbage in ["", "cvjg802", "(F(*"]) {
					var input = new TokenizerInput(
						type + whitespace + "(" + whitespace + ")" +
						whitespace + garbage
					);
					var output = TypeTestTokenizer.getInstance().tokenize(input);
					
					assertEquals(1, output.result.length);
					assertEquals(type.length + 2 + whitespace.length*3, output.characterLength);
					assertTrue(Std.is(output.result[0], TypeTestToken));
					assertEquals(types.get(type), cast(output.result[0], TypeTestToken).type);
				}
			}
		}
	}
	
	function testBad () {
		for (type in types.keys()) {
			for (whitespace in ["", " ", "   "]) {
				for (garbage in ["", "cvjg802", "(F(*"]) {
					var input = new TokenizerInput(
						type + whitespace + "(" + whitespace + garbage
					);
					
					var caught = false;
					try {
						TypeTestTokenizer.getInstance().tokenize(input);
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
