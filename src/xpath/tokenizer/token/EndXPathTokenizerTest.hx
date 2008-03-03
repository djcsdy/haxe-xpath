/* haXe XPath
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
import xpath.tokenizer.token.EndXPathTokenizer;
import xpath.tokenizer.Token;
import xpath.tokenizer.ExpectedException;


class EndXPathTokenizerTest extends TestCase {
	
	function testGood () {
		for (garbage in ["", "dgnxcmbo", "/xcv.# bcds", ",v/x l xf[kgs;"]) {
			var input = new TokenizerInput(garbage, garbage.length);
			var output = EndXPathTokenizer.getInstance().tokenize(input);
			
			assertEquals(1, output.result.length);
			assertEquals(0, output.characterLength);
			assertTrue(Std.is(output.result[0], EndXPathToken));
		}
	}
	
	function testBad () {
		for (garbage in ["dgnxcmbo", "/xcv.# bcds", ",v/x l xf[kgs;"]) {
			var input = new TokenizerInput(garbage);
			
			var caught = false;
			try {
				EndXPathTokenizer.getInstance().tokenize(input);
			} catch (exception:ExpectedException) {
				caught = true;
				assertEquals(0, exception.position);
			}
			assertTrue(caught);
		}
	}
	
}