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
import xpath.tokenizer.token.TokenTokenizer;


class TokenTokenizerTest extends TestCase {
	
	function testCountWhitespace () {
		var tokenTokenizer = new TokenTokenizerTester();
		
		for (garbage1 in ["", "gushgishrghpi", "jsfog  hsr9h49u3", " ,vmxb"]) {
			for (whitespace in ["", " ", "          "]) {
				for (garbage2 in ["", "gushgishrghpi", "jsfog  hsr9h49u3", ",vmxb "]) {
					var testString = garbage1 + whitespace + garbage2;
					var length = tokenTokenizer.testCountWhitespace(testString, garbage1.length);
					assertEquals(whitespace.length, length);
				}
			}
		}
	}
	
}

private class TokenTokenizerTester extends TokenTokenizer {
	
	public function new () {
	}
	
	public function testCountWhitespace (query:String, pos:Int) {
		return countWhitespace(query, pos);
	}
	
}
