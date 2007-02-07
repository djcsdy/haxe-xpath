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
import xpath.tokenizer.token.ArgumentDelimiterTokenizer;
import xpath.token.ArgumentDelimiterToken;


class TestArgumentDelimiterTokenizer extends TestCase {
	
	private function testGood () {
		for (whitespace in ["", " ", "     "]) {
			for (garbage in ["", ",", ",,,dfjs", "/..fgbsogjsfogjp"]) {
				var state:TokenizeState = new TokenizeState(","+whitespace+garbage);
				state = ArgumentDelimiterTokenizer.getInstance().tokenize(state);
				
				assertEquals(1, state.result.length);
				assertEquals(whitespace.length+1, state.pos);
				assertTrue(Std.is(state.result[0], ArgumentDelimiterToken));
			}
		}
	}
	
	private function testBad () {
		for (garbage in ["", " ,", "dfgnsdpobmfl", "/.gn.;fncf"]) {
			var state:TokenizeState = new TokenizeState(garbage);
			state = ArgumentDelimiterTokenizer.getInstance().tokenize(state);
			
			assertEquals(null, state.result);
			assertEquals(0, state.pos);
		}
	}
	
}