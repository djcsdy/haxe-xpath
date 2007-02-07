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
import xpath.tokenizer.token.DeepStepDelimiterTokenizer;
import xpath.token.StepDelimiterToken;
import xpath.token.AxisToken;
import xpath.token.TypeTestToken;


class TestDeepStepDelimiterTokenizer extends TestCase {
	
	private function testGood () {
		for (whitespace in ["", " ", "   "]) {
			for (garbage in ["", "fsgpjg", "/fgjsdf", "///sfgkosg"]) {
				var state:TokenizeState = new TokenizeState("//" + whitespace + garbage);
				state = DeepStepDelimiterTokenizer.getInstance().tokenize(state);
				
				assertEquals(4, state.result.length);
				assertEquals(2 + whitespace.length, state.pos);
				assertTrue(Std.is(state.result[0], StepDelimiterToken));
				assertTrue(Std.is(state.result[1], AxisToken));
				assertTrue(Std.is(state.result[2], TypeTestToken));
				assertTrue(Std.is(state.result[3], StepDelimiterToken));
				assertEquals(DescendantOrSelf, cast(state.result[1], AxisToken).axis);
				assertEquals(Node, cast(state.result[2], TypeTestToken).type);
			}
		}
	}
	
	private function testBad () {
		for (whitespace in ["", " ", "   "]) {
			for (garbage in ["", "fsgpjg", "/fgjsdf"]) {
				var state:TokenizeState = new TokenizeState(whitespace + garbage);
				state = DeepStepDelimiterTokenizer.getInstance().tokenize(state);
				
				assertEquals(null, state.result);
				assertEquals(0, state.pos);
			}
		}
	}
	
}