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


package xpath.tokenizer.util;
import Haxe.unit.TestCase;
import xpath.tokenizer.util.Disjunction;
import xpath.tokenizer.Tokenizer;
import xpath.tokenizer.TokenizerInput;
import xpath.tokenizer.TokenizerOutput;
import xpath.tokenizer.Token;
import xpath.tokenizer.ExpectedException;
import xpath.tokenizer.TokenizerError;
import xpath.tokenizer.FakeAnyCharTokenizer;
import xpath.tokenizer.FakeNeverTokenizer;


class DisjunctionTest extends TestCase {
	
	function testEmpty () {
		var caught = false;
		try {
			new Disjunction([]);
		} catch (error:TokenizerError) {
			caught = true;
		}
		assertTrue(caught);
	}
	
	function testAll () {
		var input = new TokenizerInput("abaaazzz");
		
		var tokenizer = new Disjunction([
			cast(new StringTokenizer("a"), Tokenizer),
			new StringTokenizer("b"), new StringTokenizer("aa")
		]);
		var output = tokenizer.tokenize(input);
		assertEquals(1, output.characterLength);
		assertEquals(1, output.result.length);
		assertTrue(Std.is(output.result[0], StringToken));
		assertEquals("a", cast(output.result[0], StringToken).string);
		
		output = tokenizer.tokenize(output.getNextInput());
		assertEquals(1, output.characterLength);
		assertEquals(1, output.result.length);
		assertTrue(Std.is(output.result[0], StringToken));
		assertEquals("b", cast(output.result[0], StringToken).string);
		
		output = tokenizer.tokenize(output.getNextInput());
		assertEquals(2, output.characterLength);
		assertEquals(1, output.result.length);
		assertTrue(Std.is(output.result[0], StringToken));
		assertEquals("aa", cast(output.result[0], StringToken).string);
		
		output = tokenizer.tokenize(output.getNextInput());
		assertEquals(1, output.characterLength);
		assertEquals(1, output.result.length);
		assertTrue(Std.is(output.result[0], StringToken));
		assertEquals("a", cast(output.result[0], StringToken).string);
		
		var caught = false;
		try {
			output = tokenizer.tokenize(output.getNextInput());
		} catch (exception:ExpectedException) {
			assertEquals(5, exception.position);
			caught = true;
		}
		assertTrue(caught);
	}
}

private class StringToken implements Token {
	
	public var string(default, null):String;
	
	
	public function new (string:String) {
		this.string = string;
	}
	
}

private class StringTokenizer implements Tokenizer {
	
	var string :String;
	
	
	public function new (string:String) {
		this.string = string;
	}
	
	public function tokenize (input:TokenizerInput) {
		if (input.query.substr(input.position, string.length) == string) {
			var result = [ cast(new StringToken(string), Token) ];
			var characterLength = string.length;
			return input.getOutput(result, characterLength);
		} else {
			throw new ExpectedException([{
				tokenName: "StringToken",
				position: input.position
			}]);
		}
	}
	
}
